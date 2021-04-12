#define CMDLENGTH 50
#define delimiter " | "

static const Block blocks[] = {
    {"cat /tmp/recordingicon 2>/dev/null", 0, 9},
    {"sb-music", 5, 11},
    {"sb-cpubars", 10, 18},
    {"sb-cpu", 10, 18},
    {"sb-memory", 10, 9},
    {"battery", 5, 3},
    {"battery1", 5, 3},
    {"sb-brightness", 0, 5},
    {"sb-bluetooth", 10, 8},
    {"sb-internet", 5, 4},
    {"sb-volume", 0, 10},
    {"sb-clock", 60, 1},
};
