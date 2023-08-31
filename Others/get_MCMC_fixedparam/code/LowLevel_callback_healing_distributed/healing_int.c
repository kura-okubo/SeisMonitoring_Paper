/*
 to make shared library with mac OS, 'gcc -shared -o healing_int.so healing_int.c'
 see https://docs.scipy.org/doc/scipy/tutorial/integrate.html#faster-integration-using-low-level-callback-functions (visit on 2022/08/12)
 */
#include <math.h>
double f(int n, double *x, void *user_data) {
    double t = *(double *)user_data;
    /*return c + x[0] - x[1] * x[2]; corresponds to c + x - y * z */
    return (1/x[0]) * exp(-t/x[0]); /* corresponds to  (1/tau) * np.exp(-t/tau) */
}
