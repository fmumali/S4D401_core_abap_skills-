CLASS zcl_5952_literals DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_5952_literals IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    CONSTANTS c_number TYPE i VALUE 1234.

    SELECT FROM /dmo/carrier
      FIELDS 'Hello' AS Character,
      1 AS Integer1,
      -1 AS Integer2,
      @c_number AS constant
      INTO TABLE @DATA(lt_result).

    out->write(
       EXPORTING
         data = lt_result
         name = 'RESULT'
         ).

  ENDMETHOD.
ENDCLASS.
