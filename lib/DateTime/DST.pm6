module DateTime::DST {
    use NativeCall;
    my class tm is repr('CStruct') {
        has int32 $.tm_sec;         #`/* seconds,  range 0 to 59          */
        has int32 $.tm_min;         #`/* minutes, range 0 to 59           */
        has int32 $.tm_hour;        #`/* hours, range 0 to 23             */
        has int32 $.tm_mday;        #`/* day of the month, range 1 to 31  */
        has int32 $.tm_mon;         #`/* month, range 0 to 11             */
        has int32 $.tm_year;        #`/* The number of years since 1900   */
        has int32 $.tm_wday;        #`/* day of the week, range 0 to 6    */
        has int32 $.tm_yday;        #`/* day in the year, range 0 to 365  */
        has int32 $.tm_isdst;       #`/* daylight saving time             */
    }
    my sub localtime_r(int32 is rw, tm is rw) is native(Str) { * }

    multi is-dst(Instant $time) returns Bool is export {
        my ($posix, $leap-sec) = $time.to-posix;
        callwith($posix);
    }

    multi is-dst(DateTime $time) returns Bool is export {
        callwith($time.posix);
    }

    multi is-dst(Int() $posix) returns Bool is export {
        my int32 $t = $posix;
        my tm $tm = tm.new;
        localtime_r($t, $tm);
        ?$tm.tm_isdst;
    }
}
