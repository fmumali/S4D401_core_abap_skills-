CLASS zcl_5952_aggregate_funcs DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_5952_aggregate_funcs IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT FROM /dmo/connection
         FIELDS carrier_id,
                connection_id,
                airport_from_id,
                distance
         WHERE carrier_id = 'LH'
         INTO TABLE @DATA(result_raw).

    out->write(
     EXPORTING
       data   = result_raw
       name   = 'RESULT_RAW'
   ).


*****************************************************************************
    SELECT FROM /dmo/connection
        FIELDS MAX( distance ) AS max,
               MIN( distance ) AS min,
               SUM( distance ) AS sum,
               AVG( distance ) AS avg,
               COUNT( * ) AS count,
               COUNT(  DISTINCT airport_from_id ) AS distinct_count
               WHERE carrier_id = 'LH'
        INTO TABLE @DATA(result_aggregate).

    out->write(
     EXPORTING
       data   = result_aggregate
       name   = 'RESULT_AGGREGATED'
   ).

  ENDMETHOD.
ENDCLASS.
