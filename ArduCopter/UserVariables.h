/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

// user defined variables

// example variables used in Wii camera testing - replace with your own
// variables
#ifdef USERHOOK_VARIABLES

#if WII_CAMERA == 1
WiiCamera           ircam;
int                 WiiRange=0;
int                 WiiRotation=0;
int                 WiiDisplacementX=0;
int                 WiiDisplacementY=0;
#endif  // WII_CAMERA

static mavlink_optical_flow_t raw_flow_read;
static uint64_t raw_of_last_update = 0;
static float raw_of_x_cm=0, raw_of_y_cm=0;
static int16_t raw_of_z=0;

#endif  // USERHOOK_VARIABLES


