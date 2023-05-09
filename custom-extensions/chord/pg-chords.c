#include "postgres.h";
#include "fmgr.h";
#include "utils/array.h"

#ifdef PG_MODULE_MAGIC
PG_MODULE_MAGIC;
#endif

PG_FUNCTION_INFO_V1(chord);

struct note_map {
    char *name;
    int value;
};

struct note_map note_map[] = {
    {"C", 0},
    {"C#", 1},
    {"Db", 1},
    {"D", 2},
    {"D#", 3},
    {"Eb", 3},
    {"E", 4},
    {"F", 5},
    {"F#", 6},
    {"Gb", 6},
    {"G", 7},
    {"G#", 8},
    {"Ab", 8},
    {"A", 9},
    {"A#", 10},
    {"Bb", 10},
    {"B", 11},
    {NULL, 0}
};

int note_to_value(char *note) {
    for (int i = 0; note_map[i].name != NULL; i++) {
        if (strcmp(note_map[i].name, note) == 0) {
            return note_map[i].value;
        }
    }
    return -1;
}

Datum
chord(PG_FUNCTION_ARGS)
{
    ArrayType *notes = PG_GETARG_ARRAYTYPE_P(0);
    int num_notes = ARR_DIMS(notes)[0];
    char *chord_name = "unknown";

    int chord_notes[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

    for (int i = 0; i < num_notes; i++)
    {
        char *note = (char *)ARR_DATA_PTR(notes) + i * ARR_ELEMSIZE(notes);

        int value = note_to_value(note);
        chord_notes[value] = 1;
    }

    int root_note = -1;
    for (int i = 0; i < 12; i++) {
        if (chord_notes[i] == 1) {
            root_note = i;
            break;
        }
    }

    char* *root_note_name = note_map[root_note].name;

    if (root_note == -1) {
        PG_RETURN_TEXT_P(cstring_to_text("unknown"));
    }

    int second_hit_note = -1;
    for (int i = root_note + 1; i < 12; i++) {
        if (chord_notes[i] == 1) {
            second_hit_note = i;
            break;
        }
    }

    if (second_hit_note == -1) {
        PG_RETURN_TEXT_P(cstring_to_text("unknown"));
    }

    int third_hit_note = -1;
    for (int i = second_hit_note + 1; i < 12; i++) {
        if (chord_notes[i] == 1) {
            third_hit_note = i;
            break;
        }
    }

    if (third_hit_note == -1) {
        PG_RETURN_TEXT_P(cstring_to_text("unknown"));
    }

    if(third_hit_note - second_hit_note == 4 && second_hit_note - root_note == 3) {
        chord_name = "major";
    } else if (third_hit_note - second_hit_note == 3 && second_hit_note - root_note == 4) {
        chord_name = "minor";
    } else if (third_hit_note - second_hit_note == 3 && second_hit_note - root_note == 3) {
        chord_name = "diminished";
    } else if (third_hit_note - second_hit_note == 4 && second_hit_note - root_note == 4) {
        chord_name = "augmented";
    }

    char* *chord_name_with_root = palloc(strlen(chord_name) + strlen(root_note_name) + 1);
    strcpy(chord_name_with_root, root_note_name);
    strcat(chord_name_with_root, chord_name);

    PG_RETURN_TEXT_P(cstring_to_text(chord_name_with_root));
}
