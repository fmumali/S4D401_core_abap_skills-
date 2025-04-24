CLASS zcl_5952_calc_time_date_tmstmp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_5952_calc_time_date_tmstmp IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "
    DATA: timestamp1 TYPE utclong,
          timestamp2 TYPE utclong,
          difference TYPE decfloat34,
          date_user  TYPE d,
          time_user  TYPE t.

    timestamp1 = utclong_current( ).
    out->write( |Current UTC time: { timestamp1 }| ).


    timestamp2 = utclong_add( val = timestamp1 days = 7 ).
    out->write( |Added 7 days to current UTC time { timestamp2 }| ).

    difference = utclong_diff( high = timestamp2 low = timestamp1 ).

    out->write( |Difference between timestamps in seconds: { difference } seconds| ).
    out->write( |Difference between timestamps in days: { difference / 86400 } days| ).
    out->write( |Difference between timestamps in hours: { difference / 3600 } hours| ).


    TRY.
        CONVERT UTCLONG utclong_current( )
        INTO DATE date_user
            TIME time_user
            TIME ZONE cl_abap_context_info=>get_user_time_zone(  ).
      CATCH cx_abap_context_info_error.
        "handle exception
    ENDTRY.

    out->write( |UTC timestamp split into date (type D) and time (type T )| ).
    out->write( |according to the user's time zone (cl_abap_context_info=>get_user_time_zone( ) ).| ).
    out->write( |{ date_user DATE = USER }, { time_user TIME = USER }| ).


  ENDMETHOD.
ENDCLASS.
