// =============================================================================
// -----------------------------------------------------------------------------
// Program
// -----------------------------------------------------------------------------

#include <stdio.h>
#include <windows.h>
#include <math.h>

#define MAXVOL 0x80

int main (int ArgNumber, char **ArgList, char **EnvList)

{

	// 100 = 100%
	//  80 =  50%
	//  60 =  25%
	//  40 =  12.5%
	//  20 =   6.25%
	//  00 =   3.125%

	// 100 / 100 =   1
	// 100 /  80 =   1.25
	// 100 /  60 =   1.666666666666667
	// 100 /  40 =   2.5
	// 100 /  20 =   5
	// 100 /   1 =   100


	// 00 = 80
	// 20 = 40
	// 40 = 20
	// 60 = 10
	// 80 = 08


	// 80 = 80
	// 60 = 40
	// 40 = 20
	// 20 = 10
	// 00 = 08

	// 100 = 100%
	//  C0 =  80%
	//  80 =  40%
	//  40 =  20%
	//   0 =  10%



	FILE *File = fopen ("Volumes.bin", "wb");
	int Count;

	for (Count = 0x10; Count < 0x80+0x10; Count++)
	{
		int Volume = 0x8000000 / Count;
	Volume = -(Volume-0x800000);
	Volume *= 0x90;
	Volume /= 0x80;
	Volume = -(Volume-0x800000);
		int VolAdd = Volume / (0x100 / 2);
		Volume = (0x800000 - Volume) + 0x800000;
		fputc (0x00, File);
		Volume += VolAdd;
		int VolCount;
		for (VolCount = 1; VolCount < 0x100; VolCount++)
		{
			fputc (Volume >> 0x10, File);
			Volume += VolAdd;
		}
	}

	fclose (File);
}

// =============================================================================
