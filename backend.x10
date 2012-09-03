import x10.util.ArrayList;
import x10.util.ListIterator;
import x10.io.File;
import x10.compiler.Native;
import x10.util.HashMap;

class Parameters
{
	var values:HashMap[String,Int];

	public def this(backendtype:Int)
	{
		values = new HashMap[String,Int]();
		values.put("type",backendtype);

		if(backendtype != 0) {
			values.put("numAsyncs",4);
		}
	}	

	public def getValue(name:String) : Int
	{
		if(!(name.equals("type") || name.equals("numAsyncs")))
			return -1;
		else 
			return values.get(name).value;
	}
}

public class backend
{
	val inputPath:String;
	val inputASM:ArrayList[String];
	val engine:Parser;
	val backendtype:Int;

	public def this(filename:String, params:Parameters)
	{
		backendtype = params.getValue("type");
		if( backendtype == 0) {
			engine = new Parser(new SequentialEngine());
		} else {
			engine = new Parser(new ParallelEngine(params.getValue("numAsyncs")));
		}
		inputPath = new String(filename + ".out");
		inputASM = new ArrayList[String]();

		val inputFile:File = new File(inputPath);
		for( line in inputFile.lines()) {
			inputASM.add(line);
		}
	}

	public def printASM()
	{
		val i:ListIterator[String] = inputASM.iterator();
		while(i.hasNext())
			Console.OUT.println(i.next());	
	}

	public def exec() : Long
	{
		 val time = System.nanoTime();
		 
		val i:ListIterator[String] = inputASM.iterator();
		while(i.hasNext())
			engine.exec(i.next());

		return (System.nanoTime()-time)/(1000*1000);
	}

	public static def main(argv:Array[String])
	{
		if(argv.size != 2) return;

		val filename:String = argv(0);
		val backendtype:Int = Int.parse(argv(1));
		val info:Parameters = new Parameters(backendtype);
		mat:backend = new backend(filename,info);
		val time = mat.exec();
		Console.OUT.println("Execution Time: " + time);
		//mat.printASM();
	}
}
