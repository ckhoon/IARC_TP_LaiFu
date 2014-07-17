/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-

#ifdef USERHOOK_INIT
void userhook_init()
{
    // put your initialisation code here
    // this will be called once at start-up
    hal.uartB->begin(115200,256,32); // set tx space to 32 since it's is used as a condition used in AP_HAL_AVR/uartdrivers.cpp to avoid the controller from dropping OF_msgs due to wrong decode
    mavlink_comm_1_port = hal.uartB;
}
#endif

#ifdef USERHOOK_FASTLOOP
void userhook_FastLoop()
{
    // put your 100Hz code here
    mavlink_message_t of_msg;
    mavlink_status_t of_stat;

    uint16_t nbytes = comm_get_available(MAVLINK_COMM_1);
    static uint8_t of_log_counter = 0;

    for (uint16_t i=0; i<nbytes; i++)
    {
        uint8_t c = comm_receive_ch(MAVLINK_COMM_1);
		if (mavlink_parse_char(MAVLINK_COMM_1, c, &of_msg, &of_stat)) {
			if (of_msg.msgid == MAVLINK_MSG_ID_OPTICAL_FLOW) {
				handleOfMessage(&of_msg);
				//i=nbytes;
			}
		}
    }

    of_log_counter++;
    if( of_log_counter >= 4 ) {
        of_log_counter = 0;
            Log_Write_Optflow();
    }

}

void handleOfMessage(mavlink_message_t* of_msg)
{
    mavlink_msg_optical_flow_decode(of_msg, &raw_flow_read);

    if (raw_of_last_update == 0)
    {
    	raw_of_last_update = raw_flow_read.time_usec;
    	return;
    }
    int32_t of_dt = raw_flow_read.time_usec - raw_of_last_update;
	log_of_dt = of_dt;
	raw_of_last_update = raw_flow_read.time_usec;

	if (raw_flow_read.quality > 250)
    {
		if (of_dt < 30000 && of_dt > 0){
			raw_of_y_cm += raw_flow_read.flow_comp_m_x * (float)of_dt * 0.0001; // distance / time scale = 100 / 1000000
			of_y_cm += raw_flow_read.flow_comp_m_x * (float)of_dt * 0.0001;
			raw_of_x_cm += (raw_flow_read.flow_comp_m_y) * (float)of_dt * 0.0001;
			of_x_cm += (raw_flow_read.flow_comp_m_y) * (float)of_dt * 0.0001;
		}
    }

    if (raw_flow_read.ground_distance > 0){
    	sonar_alt_health = SONAR_ALT_HEALTH_MAX;
    	int16_t new_z = (int16_t)(raw_flow_read.ground_distance * 100);
    	int16_t dz = raw_of_z - new_z;
        if(dz<150.0 && dz>-150.0){
        	raw_of_z = (new_z + raw_of_z)/2;
        }
    }

	//hal.console->printf(("\nx : %.5f _____________ y : %.5f"), raw_of_x_cm, raw_of_y_cm);
	//hal.console->printf(("\ny : - %f"), raw_of_y_cm);
}


#endif

#ifdef USERHOOK_50HZLOOP
void userhook_50Hz()
{
    // put your 50Hz code here
}
#endif

#ifdef USERHOOK_MEDIUMLOOP
void userhook_MediumLoop()
{
    // put your 10Hz code here
}
#endif

#ifdef USERHOOK_SLOWLOOP
void userhook_SlowLoop()
{
    // put your 3.3Hz code here
}
#endif

#ifdef USERHOOK_SUPERSLOWLOOP
void userhook_SuperSlowLoop()
{
    //cliSerial->print_P(PSTR("\n OR THIS -> "));
    // put your 1Hz code here
}
#endif
