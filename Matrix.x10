import x10.util.StringBuilder;
import x10.util.ArrayList;
import x10.util.Random;

public class Matrix
{
	private var data:Array[Double](2);
	public var region:Region;

	public def this(n:Double)
	{
		data = new Array[Double]((0..0)*(0..0));
		data(0,0) = n;
		region = data.region;
	}

	public def this(r:Region)
	{
		region = r;
		data = new Array[Double](r);
	}

	public def this(spec:String)
	{
		if(spec.indexOf('{') != -1)
			buildrandom(spec);
		else
			buildspecified(spec);
	}

	public def size()
	{
		return data.size;
	}

	private def buildrandom(spec:String)
	{
		val split:Int = spec.indexOf(',');
		val m:Int = Int.parse(spec.substring(1,split));
		val n:Int = Int.parse(spec.substring(split+1,spec.length()-1));
		val ran = new Random(System.currentTimeMillis());
		data = new Array[Double]((0..(m-1))*(0..(n-1)));
		for([i,j] in data.region)
			data(i,j) = Math.round(ran.nextDouble()*100);
		region = data.region;
	}
	private def buildspecified(spec:String)
	{
		val speclen:Int = spec.length();
		var currentBeginIndex:Int = 0;
		var currentEndIndex:Int = 0;
		var numElements:Int = 0;
		var buffer:ArrayList[Array[Double](1)] = 
			new ArrayList[Array[Double](1)]();
		do {
			currentBeginIndex = spec.indexOf("(",currentBeginIndex+1);
			currentEndIndex = spec.indexOf(")",currentEndIndex+1);

			val rowspec:String = 
			spec.substring(currentBeginIndex+1,currentEndIndex);

			val firstIndex:Int = rowspec.indexOf(',');
			val lastIndex:Int = rowspec.lastIndexOf(',');

			val begin = 
			Double.parse(rowspec.substring(0,firstIndex));
			val end = 
			Double.parse(rowspec.substring(firstIndex+1,lastIndex));
			val inc = 
			Double.parse(rowspec.substring(lastIndex+1,rowspec.length()));

			numElements = Int.operator_as(((end-begin)/inc)+1);
			var temp:Array[Double](1)=new Array[Double](numElements);

			var j:Int = 0;
			var i:Double = begin;
			for(;i<=end;i+=inc,j++) {
				temp(j) = i;	
			}

			buffer.add(temp);

		} while( currentEndIndex < speclen-2 );


		data = new Array[Double]((0..(buffer.size()-1))*(0..(numElements-1)));
		for(i in (0..(buffer.size()-1))) {
			val t:Array[Double](1) = buffer.get(i);
			for(j in (0..(numElements - 1))) {
				data(i,j) = t(j); 
			}
		}

		region = data.region;
	}

	public operator this (i:Int,j:Int) 
	{
		return data(i,j); 
	}
	public operator this (i:Int,j:Int) = (newval:Double)
	{
		data(i,j) = newval;
	}

	public def getNumRows() : Int { return data.region.max(0)+1;}
	public def getNumColumns() : Int { return data.region.max(1)+1;}

	public def toString() : String 
	{
		val m:Int = data.region.max(0)+1;
		val n:Int = data.region.max(1)+1;
		var s:StringBuilder = new StringBuilder();
		s.add(m+"x"+n+"\n");
		for(i in (0..(m-1))) {
			for(j in (0..(n-1))) {
				s.add(data(i,j)+"\t");
			}
			s.add("\n");
		}
		return s.result();
	}

	public def clone() : Matrix 
	{
		var c:Matrix = new Matrix(this.region);
		for([i,j] in this.region)
		{
			c(i,j) = this(i,j);
		}
		return c;
	}

	public def equals(A:Matrix) : Boolean
        {
                var good:Boolean = true;
                if((this.getNumRows() != A.getNumRows()) &&
                   (this.getNumColumns() != A.getNumColumns()))
                        return false;
                for([i,j] in this.region)
                {
                        good &= (this(i,j) == A(i,j));
                        if(!good) {
				 return false;
			}
                }
                return good;
        }
}
