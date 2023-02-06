
cdef extern from "cpl_error.h":

    ctypedef enum CPLErr:
        CE_None
        CE_Debug
        CE_Warning
        CE_Failure
        CE_Fatal

    int CPLGetLastErrorNo()
    const char* CPLGetLastErrorMsg()
    int CPLGetLastErrorType()
    void CPLErrorReset()


cdef extern from "ogr_srs_api.h":

    void OSRSetPROJSearchPaths(const char *const *papszPaths)
    void OSRGetPROJVersion	(int *pnMajor, int *pnMinor, int *pnPatch)
