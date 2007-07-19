#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <assert.h>
#include "../joystick.h"
#include "../util.h"
#include "input.h"

/* the API simulator and the real API have different named wait functions */ 
#ifdef __AVR__
	#include <avr/pgmspace.h>
	#define WAIT(ms) wait(ms)
#else
	#define PROGMEM
	#define WAIT(ms) myWait(ms)
#endif


/***********
 * defines *
 ***********/

// amount of milliseconds that each loop cycle waits
#define TETRIS_INPUT_TICKS 10

// number of loop cycles for each level until a piece gets moved down
// (the last level is merely a stuffing byte because avr-gcc causes
// trouble if you store an array with an odd number of bytes into PROGMEM)
#define TETRIS_INPUT_CYCLESPERLEVEL {100, 87, 76, 66, 57, 50, 43, 38, 33, 29, \
	25, 22, 19, 16, 14, 12, 11, 9, 8, 7}

// here you can adjust the delays (in loop cycles) for key repeat
#define TETRIS_INPUT_REPEAT_INITIALDELAY 20
#define TETRIS_INPUT_REPEAT_DELAY 5


/***************************
 * non-interface functions *
 ***************************/

/* Function:     tetris_input_chatterProtect;
 * Description:  sets initial ignore counter for a given command if it is != 0
 * Argument pIn: pointer to an input object
 * Argument cmd: the command which should be checked
 * Return value: void
 */
void tetris_input_chatterProtect (tetris_input_t *pIn,
                                  tetris_input_command_t cmd)
{
	assert(cmd < TETRIS_INCMD_NONE);
	
	// Here you can define the amount of loop cycles a command is ignored after
	// it has been issued.
	// NOTE: Hasn't been tested well for commands with key repeat, yet!
	const static uint8_t nInitialIgnoreValue[TETRIS_INCMD_NONE] PROGMEM =
	{
		0, // TETRIS_INCMD_ROT_CW
		0, // TETRIS_INCMD_ROT_CCW
		0, // TETRIS_INCMD_LEFT (key repeat)
		0, // TETRIS_INCMD_RIGHT (key repeat)
		0, // TETRIS_INCMD_DOWN (key repeat)
		6, // TETRIS_INCMD_DROP
		0, // TETRIS_INCMD_GRAVITY
		0  // TETRIS_INCMD_IGNORE (don't use it!)
	};

	if (pIn->nIgnoreCmdCounter[cmd] == 0)
	{
		#ifdef __AVR__
			pIn->nIgnoreCmdCounter[cmd] = pgm_read_word(&nInitialIgnoreValue[cmd]);
		#else
			pIn->nIgnoreCmdCounter[cmd] = nInitialIgnoreValue[cmd];
		#endif
	}
}


/* Function:     tetris_input_queryJoystick
 * Description:  translates joystick movements into tetris_input_command_t
 * Argument pIn: pointer to an input object
 * Return value: see definitition of tetris_input_command_t
 */
tetris_input_command_t tetris_input_queryJoystick()
{
	tetris_input_command_t cmdReturn;
	
	if (JOYISFIRE)
	{
		cmdReturn = TETRIS_INCMD_DROP;
	}
	else if (JOYISLEFT)
	{
		cmdReturn = TETRIS_INCMD_LEFT;
	}
	else if (JOYISRIGHT)
	{
		cmdReturn = TETRIS_INCMD_RIGHT;
	}
	else if (JOYISUP)
	{
		cmdReturn = TETRIS_INCMD_ROT_CW;
	}
	else if (JOYISDOWN)
	{
		cmdReturn = TETRIS_INCMD_DOWN;
	}
	else
	{
		cmdReturn = TETRIS_INCMD_NONE;
	}
	
	return cmdReturn;
}


/*****************************
 *  construction/destruction *
 *****************************/

/* Function:     tetris_input_construct
 * Description:  constructs an input object for André's borg
 * Return value: pointer to a newly created input object
 */
tetris_input_t *tetris_input_construct()
{
	tetris_input_t *pIn = (tetris_input_t *)malloc(sizeof(tetris_input_t));
	assert(pIn != NULL);

	pIn->cmdLast = TETRIS_INCMD_NONE;
	pIn->nLevel = 0;
	pIn->nLoopCycles = 0;
	pIn->nRepeatCount = -TETRIS_INPUT_REPEAT_INITIALDELAY;
	memset(pIn->nIgnoreCmdCounter, 0, TETRIS_INCMD_NONE);

	return pIn;
}


/* Function:     tetris_input_destruct
 * Description:  destructs an input structure
 * Argument pIn: pointer to the input object which should to be destructed
 * Return value: void
 */
void tetris_input_destruct(tetris_input_t *pIn)
{
	assert(pIn != NULL);
	free(pIn);
}


/***************************
 * input related functions *
 ***************************/

/* Function:     tetris_input_getCommand
 * Description:  retrieves commands from joystick or loop interval
 * Argument pIn: pointer to an input object
 * Return value: see definition of tetris_input_command_t
 */
tetris_input_command_t tetris_input_getCommand(tetris_input_t *pIn)
{
	assert (pIn != NULL);

	// nMaxCycles is the amount of loop cycles until a gravity command is
	// issued. Its value depends on the current level. The amount of cycles
	// for each level is defined in the ARRAY TETRIS_INPUT_CYCLESPERLEVEL.
	const static uint8_t nCyclesPerLevel[] PROGMEM =
		TETRIS_INPUT_CYCLESPERLEVEL;
	#ifdef __AVR__
		uint8_t nMaxCycles = pgm_read_word(&nCyclesPerLevel[pIn->nLevel]);
	#else
		uint8_t nMaxCycles = nCyclesPerLevel[pIn->nLevel];
	#endif

	tetris_input_command_t cmdJoystick = TETRIS_INCMD_NONE;
	tetris_input_command_t cmdReturn = TETRIS_INCMD_NONE;

	for (; pIn->nLoopCycles < nMaxCycles;)
	{
		cmdJoystick = tetris_input_queryJoystick();

		switch (cmdJoystick)
		{
		case TETRIS_INCMD_LEFT:
		case TETRIS_INCMD_RIGHT:
		case TETRIS_INCMD_DOWN:
			// only react if the ignore value for the given command is 0
			// and if either the current command differs from the last
			// or enough loop cycles have been run on the same command
			// (for key repeat)
			if (((pIn->cmdLast != cmdJoystick) || ((pIn->cmdLast == cmdJoystick)
				&& (pIn->nRepeatCount >= TETRIS_INPUT_REPEAT_DELAY)))
				&& (pIn->nIgnoreCmdCounter[cmdJoystick] == 0))
			{
				// reset repeat counter
				if (pIn->cmdLast != cmdJoystick)
				{
					// different command: we set an extra initial delay
					pIn->nRepeatCount = -TETRIS_INPUT_REPEAT_INITIALDELAY;
				}
				else
				{
					// same command: there's no extra initial delay
					pIn->nRepeatCount = 0;
				}

				// update cmdLast and return value
				pIn->cmdLast = cmdReturn = cmdJoystick;
			}
			else
			{
				// if not enough loop cycles have been run or the ignore value
				// is not 0, we increment the repeat counter and ensure that
				// we continue the loop and keep the key repeat functioning
				++pIn->nRepeatCount;
				cmdReturn = TETRIS_INCMD_NONE;
			}
			break;

		case TETRIS_INCMD_DROP:
		case TETRIS_INCMD_ROT_CW:
		case TETRIS_INCMD_ROT_CCW:
			// no key repeat here
			if ((pIn->cmdLast != cmdJoystick)
				&& (pIn->nIgnoreCmdCounter[cmdJoystick] == 0))
			{
				pIn->nRepeatCount =  -TETRIS_INPUT_REPEAT_INITIALDELAY;
				if (cmdJoystick == TETRIS_INCMD_DROP)
				{
					// reset autom. falling if player has dropped the piece
					pIn->nLoopCycles = 0;
				}

				pIn->cmdLast = cmdReturn = cmdJoystick;
			}
			else
			{
				// if we reach here the command is somehow ignored
				cmdReturn = TETRIS_INCMD_NONE;
			}
			break;

		case TETRIS_INCMD_NONE:
			// chatter protection
			if (pIn->cmdLast != TETRIS_INCMD_NONE)
			{
				tetris_input_chatterProtect(pIn, pIn->cmdLast);
			}
			pIn->cmdLast = cmdReturn = TETRIS_INCMD_NONE;
			pIn->nRepeatCount =  -TETRIS_INPUT_REPEAT_INITIALDELAY;
			break;
		}

		// chatter protection
		if (pIn->nIgnoreCmdCounter[cmdJoystick] == 0)
		{
			switch (cmdJoystick)
			{
			// suppress automatic falling if the player has dropped a piece
			case TETRIS_INCMD_DOWN:
			case TETRIS_INCMD_DROP:
				pIn->nLoopCycles = 0;
			// ensure automatic falling otherwise
			default:
				++pIn->nLoopCycles;
			}
		}
		
		// decrease all ignore counters
		for (int ignoreIndex = 0; ignoreIndex < TETRIS_INCMD_NONE; ++ignoreIndex)
		{
			if (pIn->nIgnoreCmdCounter[ignoreIndex]!= 0)
			{
				--pIn->nIgnoreCmdCounter[ignoreIndex];
			}
		}

		WAIT(TETRIS_INPUT_TICKS);
		if (cmdReturn != TETRIS_INCMD_NONE)
		{
			return cmdReturn;
		}
	}

	if (pIn->nLoopCycles >= nMaxCycles)
	{
		pIn->nLoopCycles = 0;

		// in higher levels the key repeat may actually be slower than the
		// falling speed, so if we reach here before we have run enough loop
		// cycles for down key repeat, we reset the repeat counter to ensure
		// smooth falling movements
		if (pIn->cmdLast == TETRIS_INCMD_DOWN)
		{
			pIn->nRepeatCount =  -TETRIS_INPUT_REPEAT_INITIALDELAY;
		}
	}

	return TETRIS_INCMD_GRAVITY;
}


/* Function:      tetris_input_setLevel
 * Description:   modifies time interval of input events
 * Argument pIn:  pointer to an input object
 * Argument nLvl: desired level (0 <= nLvl <= TETRIS_INPUT_LEVELS - 1)
 * Return value:  void
 */
void tetris_input_setLevel(tetris_input_t *pIn,
                           uint8_t nLvl)
{
	assert(pIn != NULL);
	assert(nLvl <= TETRIS_INPUT_LEVELS - 1);
	pIn->nLevel = nLvl;
}

