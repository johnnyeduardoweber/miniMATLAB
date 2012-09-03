/** The interface for matrix operations.
 * <p>
 * The engine interface defines all of the matrix operations 
 * supported by our language.  A language implementation must 
 * implement Engine, which is called by the parser to execute 
 * the underlying operations of the language syntax.
 * <p>
 * Matrix operations supported syntax:
 * <ul>
 * <li>A+B</li>
 * <li>A-B</li>
 * <li>A*B</li>
 * <li>A.*B</li>
 * <li>A/B</li>
 * <li>A./B</li>
 * <li>A\B</li>
 * <li>A.\B</li>
 * <li>A^B</li>
 * <li>A.^B</li>
 * <li>A'</li>
 * <li>A.'</li>
 * </ul>
 * @author Johnny Eduardo Weber (jew23 at columbia.edu)
 */
interface Engine
{
	/** Adds A and B: A + B.
	 *  A and B must have the same size unless one is a scalar.
	 * @param A - The first addend
	 * @param B - The second added
	 * @return Matrix sum(i,j) = A(i,j) + B(i,j)
	 * @throws ArithmeticException if A and B are of unequal size.
	 */
	def plus(A:Matrix,B:Matrix) : Matrix;

	/** Scalar addition: Adds x to each value in A.
	 * @param A - The matrix addend
	 * @param x - The number addend
	 * @return Matrix sum(i,j) = A(i,j) + x for all i,j
 	 */
	def plus(A:Matrix,x:Double) : Matrix;

	/** Subtracts B from A: A - B.
	 * A and B must have the same size unless one is a scalar.
	 * @param A - The minuend
	 * @param B - The subtrahend
	 * @return Matrix difference(i,j) = A(i,j) - B(i,j)
	 * @throws ArithmeticException if A and B are of unequal size.
	 */
	def minus(A:Matrix,B:Matrix) : Matrix;

	/** Scalar subtraction: Subtracts x from each value in A.
	 * Subtracting a Matrix from a scalar is equivalent to:
	 * add(multiply(A,-1),x)
	 * @param A - A matrix to subtract from
	 * @param x - A value to subtract
	 * @return Matrix difference(i,j) = A(i,j) - x for all i,j
	 */
	def minus(A:Matrix,x:Double) : Matrix;

	/** The linear algebraic product of A and B: A * B.
	 * @param A - The multiplicand
	 * @param B - The multiplier
	 * @return Matrix product(i,j) = sum_k{1,n} A(i,k) * B(k,j)
	 * @throws ArithmeticException if the columns of A neq rows of B.
	 */
	def mtimes(A:Matrix,B:Matrix) : Matrix; 

	/** Multiplies corresponding elements of matrices A and B: A .* B.
	 * A and B must have the same size unless one is a scalar.
	 * @param A - The multiplicand
	 * @param B - The multiplier
	 * @return Matrix product(i,j) = A(i,j) * B(i,j)
	 * @throws ArithmeticException if A and B are of unequal size.
	 */
	def times(A:Matrix,B:Matrix) : Matrix;

	/** Multiplies each element of A by x.
	 * @param A - The multiplicand
	 * @param x - The multiplier
	 * @return Matrix product(i,j) = A(i,j) * x
	 */
	def times(A:Matrix,x:Double) : Matrix;

	/** Matrix right division: A / B.
	 * If B is a scalar this is equivalent to A ./ B.
	 * @param A - The dividend
	 * @param B - The divisor
	 * @raturn Matrix quotient = A * inv(B)
	 * @throws ArithmeticException if A and B are of unequal column size.
	 */
	def mrdivide(A:Matrix,B:Matrix) : Matrix;

	/** Array right division: A ./ B.
	 * Divides each entry of A by the corresponding entry of B.
	 * @param A - The dividend
	 * @param B - The divisor
	 * @return Matrix quotient(i,j) = A(i,j) / B(i,j)
	 * @throws ArithmeticException if A and B are of unequal size.
	 */
	def rdivide(A:Matrix,B:Matrix) : Matrix;

	/** Scalar right division: A ./ x
	 * Divides each entry of A by x.
	 * @param A - The dividend
	 * @param x - The divisor
	 * @return Matrix quotient(i,j) = A(i,j) / x
	 */
	def rdivide(A:Matrix,x:Double) : Matrix;

	/** Matrix left division: A \ B.
	 * If A is a scalar this is equivalent to A .\ B.
	 * @param A - The dividend
	 * @param B - The divisor 
	 * @return Matrix quotient = inv(A) * B
	 * @throws ArithmeticException if A and B are of unequal row size.
 	 */
	def mldivide(A:Matrix,B:Matrix) : Matrix;
	
	/** Array left division: A .\ B.
	 * Divides each entry of B by the corresponding entry of A.
	 * @param A - The divisor
	 * @param B - The dividend
	 * @return quotient(i,j) = B(i,j) / A(i,j)
	 */
	def ldivide(A:Matrix,B:Matrix) : Matrix;

	/** Scalar left division: A .\ x.
 	 * Divides x by each element of A.
	 * @param A - The divisors
	 * @param x - The dividend
	 * @return Matrix quotient(i,j) = x / A(i,j)
	 */
	def ldivide(A:Matrix,x:Double) : Matrix;

	/** A to the power of p by repeated squaring.
	 * @param A - The base
	 * @param p - The 1x1 matrix cast to Int
	 * @return Matrix result = p terms of { A * A * ... * A}
	 * @throws ArithmeticException if p is not a scalar
	 */
	def mpower(A:Matrix,B:Matrix) : Matrix;

	/** A to the power of p by repeated squaring.
	 * @param A - The base
	 * @param p - The power
	 * @return Matrix result = p terms of { A * A * ... * A}
 	 */
	def mpower(A:Matrix,p:Int) : Matrix;

	/** The element-by-element X to the power of B.
	 * A and B must have the size unless one is a scalar.
	 * @param A - The bases
	 * @param B - The powers
	 * @return Matrix result(i,j) = A(i,j) to the power of B(i,j)
	 * @throws ArithmeticException if A and B are of unequal size.
	 */
	def power(A:Matrix,B:Matrix) : Matrix;

	/** Matrix A to the scalar power x.
	 * @param A - The bases
	 * @param x - The power
	 * @return Matrix result(i,j) = A(i,j) to the power of x.
	 */
	def rpower(A:Matrix,x:Double) : Matrix;

	/** Scalar x to the powers of A.
	 * @param A - The powers
	 * @param x - The base
	 * @return Matrix result(i,j) = x to the power of A(i,j).
	 */
	def lpower(A:Matrix,x:Double) : Matrix;

	/** The linear algebraic transpose: A.'
 	 * Because the system does not support complex values, 
	 * this is equivalent to A'.
	 * @param A - The m by n matrix to transpose
	 * @return Matrix n by m with A's ith row being its ith column.
	 */
	def transpose(A:Matrix) : Matrix;
	
	/** The transposition of a scalar: x'.
	 * @param x - A scalar value
	 * @return The same value.
 	 */
	def transpose(x:Double) : Double;

	/** The inverse of the matrix A.
	 * @param A - The matrix to invert.
	 * @return The matrix B such that A * B = I (diag matrix 1)
	 * @throws ArithmeticException if A is not a square matrix.
 	 */
	def invert(A:Matrix) : Matrix;

	/** The scalar multiplicative inverse.
	 * @param x - A scalar value.
	 * @return The value 1/x so that x * 1/x = I (1)
	 * @throws ArithmeticException if x is equal to 0.
	 */
	def invert(x:Double) : Double;

	/** Round the matrix.
	 * @param A - the matrix of floating point values
	 * @return A rounded to the nearest integer.
	 */
	def round(A:Matrix) : Matrix;

	/** Round the matrix.
	 * @param A - the matrix of floating point values
	 * @param n - The decimal place
	 * @return A rounded to the nth decimal place.
	 */
	def round(A:Matrix,n:Int) : Matrix;

	/** Round the number.
	 * @param x - Floating point number
	 * @return x rounded to the nearest integer.
	 */
	def round(x:Double) : Double;

	/** Round the number.
	 * @param x - Floating point number
	 * @param n - The decical place
	 * @return x rounded to the nth decimal place.
	 */
	def round(x:Double,n:Int) : Double;
}
