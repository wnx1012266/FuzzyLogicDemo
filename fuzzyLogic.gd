class_name FuzzyLogic

func FuzzyGrade(value, x0, x1):
	var result = 0.0;
	var x = value;

	if(x <= x0):
		result = 0.0;
	elif(x >= x1):
		result = 1.0;
	else:
		result = (x/(x1-x0))-(x0/(x1-x0));

	return result;

func FuzzyReverseGrade(value, x0, x1):
	var result = 0.0;
	var x = value;

	if(x <= x0):
		result = 1.0;
	elif(x >= x1):
		result = 0.0;
	else:
		result = (-x/(x1-x0))+(x1/(x1-x0));

	return result;

func FuzzyTriangle( value,  x0,  x1,  x2):
	var result = 0.0;
	var x = value;

	if(x <= x0):
		result = 0.0;
	elif(x == x1):
		result = 1.0;
	elif((x>x0) and (x<x1)):
		result = (x/(x1-x0))-(x0/(x1-x0));
	else:
		result = (-x/(x2-x1))+(x2/(x2-x1));

	return result;

func FuzzyTrapezoid( value,  x0,  x1,  x2,  x3):
	var result = 0.0;
	var x = value;

	if(x <= x0):
		result = 0.0;
	elif((x>=x1) and (x<=x2)):
		result = 1.0;
	elif((x>x0) and (x<x1)):
		result = (x/(x1-x0))-(x0/(x1-x0));
	else:
		result = (-x/(x3-x2))+(x3/(x3-x2));

	return result;

func FuzzyAND( A,  B):
	return min(A, B);

func FuzzyOR( A,  B):
	return max(A, B);

func FuzzyNOT( A):
	return 1.0 - A;
