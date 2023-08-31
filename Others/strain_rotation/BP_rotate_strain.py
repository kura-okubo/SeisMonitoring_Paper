# BP rotate strain functions
import numpy as np

def DiracDelta(k1,k2):
    if k1 == k2:
        return 1
    else:
        return 0


def rotate_strain(Eee, Enn, Een, theta_deg):
	"""
	Return the components of rotated strain tensor with anticlockwise of theta [deg]
	Note that the theta_deg is the rotation from north to west.
	Then the first and second axes correspond to fault-normal and fault-parallel components, respectively.
    Here we use the notation of Efn: fault-normal and Efp: fault-parallel due to the early development of function.
    The fault is assumed to be parallel to the NS direction, and theta_deg indicates the angle from north to west of the rotated fault.
    You can replace this notation simply by Exx, Eyy and Exy.
	"""
	theta = np.deg2rad(theta_deg)
	s = np.sin(theta)
	c = np.cos(theta)

	Efn = Eee*(c**2) + Enn*(s**2) + 2*Een*s*c
	Efp = Eee*(s**2) + Enn*(c**2) - 2*Een*s*c
	Ess = (Enn - Eee) * s * c + Een * (c**2 - s**2)

	# assert the invariants
	eps = 1e-11 # This threshold is for the rounded error.
	I1_0 = Eee + Enn
	I2_0 = Eee *Enn - Een**2

	I1_1 = Efn + Efp
	I2_1 = Efn *Efp - Ess**2

	# print(I1_0, I1_1, I2_0, I2_1)
	assert (np.abs(I1_0 - I1_1) < eps)
	assert (np.abs(I2_0 - I2_1) < eps)

	return(Efn, Efp, Ess)

def compute_strain(sxx, syy, tau, E, nu):
    s1 = np.asarray([[sxx, tau, 0], [tau, syy, 0], [0, 0, nu * (sxx + syy)]])
    e1= []
    #Plane strain condition so that strain 13 = 23 = 33 = 0
    for m1 in range(3):
        e1_tempcol = []

        for n1 in range(3):
            e1_component = ((1.0 + nu) * s1[m1][n1] - nu * (s1[0][0] + s1[1][1] + s1[2][2]) * DiracDelta(m1, n1)) / E
            e1_tempcol.append(e1_component)

        e1.append(e1_tempcol)

    return e1

def compute_axialstrain(Eee, Enn, Een, theta_deg):
    """
    Return the component of axial strain rotated with anticlockwise of theta [deg] from east.
    The unit vector of the returned strain component is [cos(theta), sin(theta)].
    """
    theta = np.deg2rad(theta_deg)
    return Eee*np.cos(theta)**2 + Een*np.sin(2*theta) + Enn*np.sin(theta)**2
