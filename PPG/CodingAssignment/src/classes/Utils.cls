/**
 * Created by Mike Weiss on 4/28/2019.
 *
 * Utility class for commonly used functions
 */

public with sharing class Utils {

    // Utility function to return if a passed object list is null or empty
    public static Boolean isListNullOrEmpty (List<Object> passedList) {
        if (passedList != null && passedList.size() > 0) {
            return false;
        }

        return true;
    }

    // Utility function to return if a passed object map is null or empty
    public static Boolean isMapNullOrEmpty (Map<Id, Object> passedMapped) {
        if (passedMapped != null && passedMapped.size() > 0) {
            return false;
        }

        return true;
    }
}