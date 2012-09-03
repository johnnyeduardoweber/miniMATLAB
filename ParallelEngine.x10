/**
 * Parallel implementation of the miniMATLAB engine.
 * @author Johnny Eduardo Weber (jew23)
 */
import x10.util.ArrayList;
public class ParallelEngine implements Engine
{
	private val numAsyncs:Int;

	public def this(numAsyncs:Int)
	{
		this.numAsyncs = numAsyncs;
	}

	/** A + B
	 */
	public def plus(A:Matrix,B:Matrix) : Matrix
	{
		if(A.size() == 1) return plus(B,A(0,0));
		if(B.size() == 1) return plus(A,B(0,0));
		result:Matrix = new Matrix(A.region);
		if(A.region.equals(B.region)) {
			val m:Int = A.region.max(0);
			val n:Int = A.region.max(1);
			var i:Int = 0;
			finish for(i=0;i<=m;i++) {
				val k:Int = i;
				async for(var j:Int=0;j<=n;j++) {
				result(k,j) = A(k,j) + B(k,j);
				}
			}
		} else {
			throw new ArithmeticException("PLUS: Size mismatch.");
		}
		return result;

	}
	public def plus(A:Matrix,x:Double) : Matrix 
	{
		result:Matrix = new Matrix(A.region);
		val m:Int = A.region.max(0);
		val n:Int = A.region.max(1);
		var i:Int = 0;
		finish for(i=0;i<=m;i++) {
			val k:Int = i;
			async for(var j:Int=0;j<=n;j++) {
			result(k,j) = A(k,j) + x;
			}
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
		val m:Int = A.region.max(0);
		val n:Int = A.region.max(1);
		var i:Int = 0;
			finish for(i=0;i<=m;i++) {
				val k:Int = i;
				async for(var j:Int=0;j<=n;j++) {
				result(k,j) = A(k,j) - B(k,j);
				}
			}
		} else {
			throw new ArithmeticException("MINUS: Size mismatch.");
		}
		return result;
	}
	public def minus(A:Matrix,x:Double) : Matrix 
	{
		result:Matrix = new Matrix(A.region);
		val m:Int = A.region.max(0);
		val n:Int = A.region.max(1);
		var i:Int = 0;
		finish for(i=0; i<=m;i++) {
		val k:Int = i;
		async for(var j:Int=0; j<=n;j++) {
			result(k,j) = A(k,j) - x;
		}
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
			finish for(k in (0..Bn)) 
				async { for(i in (0..Am)) 
					for(j in (0..Bm)) 
						result(i,k) += A(i,j) * B(j,k);
				}
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
			val m:Int = A.region.max(0);
			val n:Int = A.region.max(1);
			var i:Int = 0;
			finish for(i=0;i<=m;i++) {
				val k:Int = i;
				async for(var j:Int=0;j<=n;j++) {
				result(k,j) = A(k,j) * B(k,j);
				}
			}
		} else {
			throw new ArithmeticException("TIMES: Size mismatch.");
		}
		return result;

	}
	public def times(A:Matrix,x:Double) : Matrix 
	{
		result:Matrix = new Matrix(A.region);
		val m:Int = A.region.max(0);
		val n:Int = A.region.max(1);
		var i:Int = 0;
		finish for(i=0;i<=m;i++) {
			val k:Int = i;	
			async for(var j:Int=0;j<=n;j++) {
			result(k,j) = A(k,j) * x;
			}
		}
		return result;
	}

	/** A / B
	 */
	public def mrdivide(A:Matrix,B:Matrix) : Matrix 
	{
		if(B.size() == 1) return rdivide(A,B(0,0));
		result:Matrix = new Matrix(A.region);
		if(A.region.equals(B.region)) {
			return mtimes(A,invert(B));
		} else {
			throw new ArithmeticException("RDIV: Column mismatch");
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
			val m:Int = A.region.max(0);
			val n:Int = A.region.max(1);
			var i:Int = 0;
			finish for(i=0;i<=m;i++) {
				val k:Int = i;
				async for(var j:Int=0;j<=n;j++) {
				result(k,j) = A(k,j) / B(k,j);
				}
			}
		} else {
			throw new ArithmeticException("RDIV: Size mismatch.");
		}
		return result;

	}
	public def rdivide(A:Matrix,x:Double) : Matrix 
	{
		result:Matrix = new Matrix(A.region);
		val m:Int = A.region.max(0);
		val n:Int = A.region.max(1);
		var i:Int = 0;
		finish for(i=0;i<=m;i++) {
			val k:Int = i;
			async for(var j:Int=0;j<=n;j++) {
			result(k,j) = A(k,j) / x;	
			}
		}
		return result;
	}

	/** A \ B
	 */
	public def mldivide(A:Matrix,B:Matrix) : Matrix 
	{
		if(B.size() == 1) return ldivide(B,A(0,0));
		val Am = A.region.max(0);
		val Bm = B.region.max(0);
		if(Am == Bm) {
			return mtimes(invert(A),B);
		} else {
			throw new ArithmeticException("LDIV: Column mismatch");
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
			val m:Int = A.region.max(0);
			val n:Int = A.region.max(1);
			var i:Int = 0;
			finish for(i=0;i<=m;i++) {
				val k:Int = i;
				async for(var j:Int=0;j<=n;j++) {
				result(k,j) = B(k,j) / A(k,j);
				}
			}
		} else {
			throw new ArithmeticException("LDIV: Size mismatch.");
		}
		return result;

	}
	public def ldivide(A:Matrix,x:Double) : Matrix 
	{
		result:Matrix = new Matrix(A.region);
		val m:Int = A.region.max(0);
		val n:Int = A.region.max(1);
		var i:Int = 0;
		finish for(i=0;i<=m;i++) {
			val k:Int = i;
			async for(var j:Int=0;j<=n;j++) {
			result(k,j) = x / A(k,j);	
			}
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
			throw new ArithmeticException("POW must be a number.");
		}
	}
	public def mpower(A:Matrix,p:Int) : Matrix
	{
		if(p < 0) return mpower(invert(A),-p);
		if(p == 0) return mtimes(A,invert(A));	
		var input:ArrayList[Matrix] = new ArrayList[Matrix](p);
		for(var i:Int=0;i<p;i++) input.add(A);
		var results:ArrayList[Matrix];
		var numIts:Int = p;
		do {
			results = new ArrayList[Matrix]();
			var i:Int;
			finish for(i=0;i<numIts-1;i+=2) {
				val k:Int = i;
				async {
					val tmp:Matrix = 
					mtimes(input(k),input(k+1));
					atomic results.add(tmp);
				}
			}
			if(numIts%2 == 1) results.add(input(input.size()-1));
			input = ArrayList.make(results);
			numIts = input.size();
		} while(results.size() > 1);
		return results(0);
	}

	/** A .^ B
	 */
	public def power(A:Matrix,B:Matrix) : Matrix
	{
		if(A.size() == 1) return lpower(B,A(0,0));
		if(B.size() == 1) return rpower(A,B(0,0));
		result:Matrix = new Matrix(A.region);
		if(A.region.equals(B.region)) {
			val m:Int = A.region.max(0);
			val n:Int = A.region.max(1);
			var i:Int = 0;
			finish for(i=0;i<=m;i++) {
				val k:Int = i;
				async for(var j:Int=0;j<=n;j++) {
				result(k,j) = Math.pow(A(k,j),B(k,j));
				}
			}
		} else {
			throw new ArithmeticException("POWER: Size mismatch.");
		}
		return result;

	}
	public def lpower(A:Matrix,x:Double) : Matrix 
	{
		result:Matrix = new Matrix(A.region);
		val m:Int = A.region.max(0);
		val n:Int = A.region.max(1);
		var i:Int = 0;
		finish for(i=0;i<=m;i++) {
			val k:Int = i;
			async for(var j:Int=0;j<=n;j++) {
			result(k,j) = Math.pow(x,A(k,j));	
			}
		}
		return result;
	}
	public def rpower(A:Matrix,x:Double) : Matrix 
	{
		result:Matrix = new Matrix(A.region);
		val m:Int = A.region.max(0);
		val n:Int = A.region.max(1);
		var i:Int = 0;
		finish for(i=0;i<=m;i++) {
			val k:Int = i;
			async for(var j:Int=0;j<=n;j++) {
			result(k,j) = Math.pow(A(k,j),x);	
			}
		}
		return result;
	}

	/** A'
	 */
	public def transpose(A:Matrix) : Matrix 
	{
		if(A.size() == 1) return A;
		m:Int = A.region.max(0);
		n:Int = A.region.max(1);
		result:Matrix = new Matrix((0..n)*(0..m));
		var i:Int;
		finish for(i=0;i<=m;i++) { 
			val k:Int = i;
			async for(var j:Int=0;j<=n;j++) 
				result(j,k) = A(k,j);
		}
		return result;
	}
	public def transpose(x:Double) : Double
	{
		return x;
	}

	/** inv(A)
	 */
	public def invert(A:Matrix) : Matrix {
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
		finish for (var i:Int=0; i<n; ++i) {
			val k:Int = i;
			async {
				var c1:Double = 0;
				for (var j:Int=0; j<n; ++j) {
					var c0:Double = Math.abs(a(k,j));
					if (c0 > c1) c1 = c0;
				}
				c(k) = c1;
			}
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
		finish {
			for (var i:Int=0; i<n; ++i) {
				val t:Int = i;
				result(n-1,t) = b(index(n-1),t)/a(index(n-1),n-1);
				async {
					for (var j:Int=n-2; j>=0; --j) {
					   result(j,t) = b(index(j),t);
					   for (var k:Int=j+1; k<n; ++k) {
						result(j,t) -= a(index(j),k) * result(k,t);
					   }
					   result(j,t) /= a(index(j),j);
					}
				}
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
                result:Matrix = new Matrix(A.region);
                val m:Int = A.region.max(0);
                val n:Int = A.region.max(1);
                var i:Int = 0;
                finish for(i=0;i<=m;i++) {
                          val k:Int = i;
                          async for(var j:Int=0;j<=n;j++) {
                          result(k,j) = Math.round(A(k,j));
                          }
                       }
                return result;
        }
        public def round(A:Matrix,n:Int) : Matrix
        {
                result:Matrix = new Matrix(A.region);
		root:Double = Math.pow(10,n);
                val Am:Int = A.region.max(0);
                val An:Int = A.region.max(1);
                var i:Int = 0;
                finish for(i=0;i<=Am;i++) {
                          val k:Int = i;
                          async for(var j:Int=0;j<=An;j++) {
                          result(k,j) = Math.round(A(k,j)*root)/root;
                          }
                       }
                return result;
        }

	public def round(x:Double) : Double = Math.round(x);
	public def round(x:Double,n:Int) : Double 
	{
		val root:Double = Math.pow(10,n);
		return Math.round(x * root) / root;
	}
}
