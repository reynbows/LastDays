// Copyright 1998-2019 Epic Games, Inc. All Rights Reserved.

#include "LaInvencionGameMode.h"
#include "LaInvencionCharacter.h"
#include "UObject/ConstructorHelpers.h"

ALaInvencionGameMode::ALaInvencionGameMode()
{
	// set default pawn class to our Blueprinted character
	static ConstructorHelpers::FClassFinder<APawn> PlayerPawnBPClass(TEXT("/Game/PersistentBlueprints/ThirdPersonCharacter"));
	if (PlayerPawnBPClass.Class != NULL)
	{
		DefaultPawnClass = PlayerPawnBPClass.Class;
	}
}
