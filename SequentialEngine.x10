/**
 * Sequential implementation of the miniMATLAB engine.
 * @author Johnny Eduardo Weber (jew23)
 */
public class SequentialEngine implements Engine
{
	/** A + B
	 */
	public def plus(A:Matrix,B:Matrix) : Matrix
	{
		if(A.size() == 1) return plus(B,A(0,0));
		if(B.size() == 1) return plus(A,B(0,0));
		result:Matrix = new Matrix(A.region);
		if(A.region.equals(B.region)) {
			for([i,j] in A.region)
				result(i,j) = A(i,j) + B(i,j);
		} else {
			throw new ArithmeticException("PLUS: Size mismatch.");
		}
		return result;

	}
	public def plus(A:Matrix,x:Double) : Matrix 
	{
		result:Matrix = new Matrix(A.region);
		for([i,j] in A.region) {
			result(i,j) = A(i,j) + x;
		}
		return result;
	}

	/** A - B
	 */
	public def minus(A:Matrix,B:Matrix) : Matrix 
	{
		if(A.size() == 1) return plus(times(B,-1),A(0,0));
		if(B.size() == 1) return minus(A,B(0,0));
		result:Matrix = new Matrix(A.region);
		if(A.region.equals(B.region)) {
			for([i,j] in A.region)
				result(i,j) = A(i,j) - B(i,j);
		} else {
			throw new ArithmeticException("MINUS: Size mismatch.");
		}
		return result;
	}
	public def minus(A:Matrix,x:Double) : Matrix 
	{
		result:Matrix = new Matrix(A.region);
		for([i,j] in A.region) {
			result(i,j) = A(i,j) - x;
		}
		return result;
	}


	/** A * B
	 */
	public def mtimes(A:Matrix,B:Matrix) : Matrix 
	{
		if(A.size() == 1) return times(B,A(0,0));
		if(B.size() == 1) return times(A,B(0,0));
		val Am = A.region.max(0);
		val An = A.region.max(1);
		val Bm = B.region.max(0);
		val Bn = B.region.max(1);
		result:Matrix = new Matrix((0..Am)*(0..Bn));
		if( (Am == Bn) && (An == Bm) ) {
			for(k in (0..Bn))
				for(i in (0..Am))
					for(j in (0..Bm)) 
						result(i,k) += A(i,j) * B(j,k);
		} else {
			throw new ArithmeticException("MTIMES: Size mismatch.");
		} 
		return result;
	}

	/** A .* B
	 */
	public def times(A:Matrix,B:Matrix) : Matrix
	{
		if(A.size() == 1) return times(B,A(0,0));
		if(B.size() == 1) return times(A,B(0,0));
		result:Matrix = new Matrix(A.region);
		if(A.region.equals(B.region)) {
			for([i,j] in A.region)
				result(i,j) = A(i,j) * B(i,j);
		} else {
			throw new ArithmeticException("TIMES: Size mismatch.");
		}
		return result;

	}
	public def times(A:Matrix,x:Double) : Matrix 
	{
		result:Matrix = new Matrix(A.region);
		for([i,j] in A.region) {
			result(i,j) = A(i,j) * x;
		}
		return result;
	}

	/** A / B
	 */
	public def mrdivide(A:Matrix,B:Matrix) : Matrix 
	{
		if(B.size() == 1) return rdivide(A,B(0,0));
		val An = A.region.max(1);
		val Bn = B.region.max(1);
		if(An == Bn) {
			return mtimes(A,invert(B));
		} else {
			throw new ArithmeticException("RDIV: Column mismatch.");
		}
	}

	/** A ./ B 
	 */
        public def rdivide(A:Matrix,B:Matrix) : Matrix
        {
                if(A.size() == 1) return ldivide(B,A(0,0));
                if(B.size() == 1) return rdivide(A,B(0,0));
                result:Matrix = new Matrix(A.region);
                if(A.region.equals(B.region)) {
                        for([i,j] in A.region)
                                result(i,j) = A(i,j) / B(i,j);
                } else {
                        throw new ArithmeticException("RDIV: Size mismatch.");
                }
                return result;
        }
	public def rdivide(A:Matrix,x:Double) : Matrix 
	{
		if(x==0.0) throw new ArithmeticException("RDIV: Divide by 0.");
		result:Matrix = new Matrix(A.region);
		for([i,j] in A.region) {
			result(i,j) = A(i,j) / x;	
		}
		return result;
	}

	/** A \ B
	 */
	public def mldivide(A:Matrix,B:Matrix) : Matrix 
	{
		if(A.size() == 1) return ldivide(B,A(0,0));
		val Am = A.region.max(0);
		val Bm = B.region.max(0);
		if(Am == Bm) {
			return mtimes(invert(A),B);
		} else {
			throw new ArithmeticException("LDIV: Row mismatch.");
		}
	}

	/** A .\ B
	 */
        public def ldivide(A:Matrix,B:Matrix) : Matrix
        {
                if(A.size() == 1) return rdivide(B,A(0,0));
                if(B.size() == 1) return ldivide(A,B(0,0));
                result:Matrix = new Matrix(A.region);
                if(A.region.equals(B.region)) {
                        for([i,j] in A.region)
                                result(i,j) = B(i,j) / A(i,j);
                } else {
                        throw new ArithmeticException("LDIV: Size mismatch.");
                }
                return result;

        }
	public def ldivide(A:Matrix,x:Double) : Matrix 
	{
		result:Matrix = new Matrix(A.region);
		for([i,j] in A.region) {
			result(i,j) = x / A(i,j);	
		}
		return result;
	}

	/** A ^ p
	 */
	public def mpower(A:Matrix,B:Matrix) : Matrix
	{
		if(B.size() == 1) {
			return mpower(A,Int.operator_as(B(0,0)));
		} else {
			throw new ArithmeticException("POW must be a number");
		}
	}
	public def mpower(A:Matrix,p:Int) : Matrix
	{
		if(p < 1) return mpower(invert(A),-p);
		if(p == 0) return mtimes(A,invert(A));
		var result:Matrix = A.clone();
		for(var i:Int = 1; i<p; i++) {
			result = mtimes(result,A);
		}
		return result;
	}

	/** A .^ B
	 */
	public def power(A:Matrix,B:Matrix) : Matrix
	{
		if(A.size() == 1) return lpower(B,A(0,0));	
		if(B.size() == 1) return rpower(A,B(0,0));
                var result:Matrix = new Matrix(A.region);
                if(A.region.equals(B.region)) {
                        for([i,j] in A.region)
                                result(i,j) = Math.pow(A(i,j),B(i,j));
                } else {
                        throw new ArithmeticException("POWER: Size mismatch.");
                }
                return result;
	}
	public def lpower(A:Matrix,x:Double) : Matrix
	{
		var result:Matrix = new Matrix(A.region);
		for([i,j] in A.region)
			result(i,j) = Math.pow(x,A(i,j));	
		return result;
	}
	public def rpower(A:Matrix,x:Double) : Matrix
	{
		var result:Matrix = new Matrix(A.region);
		for([i,j] in A.region)
			result(i,j) = Math.pow(A(i,j),x);	
		return result;
	}

	/** A'
	 */
	public def transpose(A:Matrix) : Matrix 
	{
		if(A.size() == 1) return A;
		m:Int = A.region.max(0);
		n:Int = A.region.max(1);
		var result:Matrix = new Matrix((0..n)*(0..m));
		var i:Int;
		var j:Int;
		for(i=0;i<=m;i++) 
			for(j=0;j<=n;j++) 
				result(j,i) = A(i,j);
		return result;
	}
	public def transpose(x:Double) : Double
	{
		return x;
	}
 
	/** inv(A)
	 */
	public def invert(A:Matrix) : Matrix 
	{
		if(A.size() == 1) return new Matrix(1/A(0,0));
 		var a:Matrix = A.clone();
		var b:Matrix = new Matrix(a.region);
		var result:Matrix = new Matrix(a.region);
		val n:Int = a.getNumColumns();
		var index:Array[Int](1) = new Array[Int](n);

 		// Create an identity matrix
		for (var i:Int=0; i<n; ++i) b(i,i) = 1;
 
		// Transform the matrix into an upper triangle
		var c:Array[Double](1) = new Array[Double](n);

		// Initialize the index
		for (var i:Int=0; i<n; ++i) index(i) = i;

 		// Find the rescaling factors, one from each row
		for (var i:Int=0; i<n; ++i) {
			var c1:Double = 0;
			for (var j:Int=0; j<n; ++j) {
				var c0:Double = Math.abs(a(i,j));
				if (c0 > c1) c1 = c0;
			}
			c(i) = c1;
		}

 		// Search the pivoting element from each column
		var ind:Int = 0;
		for (var j:Int=0; j<n-1; ++j) {
			var pi1:Double = 0;
			for (var i:Int=j; i<n; ++i) {
				var pi0:Double = Math.abs(a(index(i),j));
				pi0 /= c(index(i));
				if (pi0 > pi1) {
					pi1 = pi0;
					ind = i;
				}
			}

			// Interchange rows according to the pivoting order
			var itmp:Int = index(j);
			index(j) = index(ind);
			index(ind) = itmp;
			for (var i:Int=j+1; i<n; ++i) {
				var pj:Double = a(index(i),j)/a(index(j),j);

				// Record pivoting ratios below the diagonal
				a(index(i),j) = pj;

				// Modify other elements accordingly
				for (var l:Int=j+1; l<n; ++l)
					a(index(i),l) -= pj * a(index(j),l);
			}
		}

 		// Update the matrix b[i][j] with the ratios stored
		for (var i:Int=0; i<n-1; ++i)
		   for (var j:Int=i+1; j<n; ++j)
			for (var k:Int=0; k<n; ++k)
				b(index(j),k) -= a(index(j),i) * b(index(i),k);
 
		// Perform backward substitutions
		for (var i:Int=0; i<n; ++i) {
		   result(n-1,i) = b(index(n-1),i)/a(index(n-1),n-1);
			for (var j:Int=n-2; j>=0; --j) {
			   result(j,i) = b(index(j),i);
			   for (var k:Int=j+1; k<n; ++k) {
				result(j,i) -= a(index(j),k) * result(k,i);
			   }
			   result(j,i) /= a(index(j),j);
			}
		}

		return result;
	}
	public def invert(x:Double) : Double
	{
		return 1/x;
	}

	/** round(A)
	 */
        public def round(A:Matrix) : Matrix 
        {
		var result:Matrix = new Matrix(A.region);
		for([i,j] in A.region)
                	result(i,j) = Math.round(A(i,j));
		return result;
        }
        public def round(A:Matrix,n:Int) : Matrix 
        {
                val root:Double = Math.pow(10,n);
		var result:Matrix = new Matrix(A.region);
		for([i,j] in A.region)
                	result(i,j) = Math.round(A(i,j) * root) / root;
		return result;
        }
	public def round(x:Double) : Double = Math.round(x);
	public def round(x:Double,n:Int) : Double
	{
                val root:Double = Math.pow(10,n);
                return Math.round(x * root) / root;
	}
}
