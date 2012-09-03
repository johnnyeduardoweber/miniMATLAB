import x10.util.HashMap;

class ParserException extends Exception
{
	public def this() { super();}
	public def this(msg:String) {super(msg);}
}

public class Parser
{
	private var eng:Engine;
	private var symt:HashMap[String,Matrix];

	public def this(impl:Engine)
	{
		eng = impl;
		symt = new HashMap[String,Matrix]();
	}

	protected def putObject(name:String,value:Matrix)
	{
		symt.put(name,value);
	}

	protected def getObject(name:String) : Matrix
	{
		return symt.get(name).value;
	}

	public static def isNumber(i:String) : Boolean
	{
		try {
			Double.parse(i);
		} catch(NumberFormatException) {
			return false;
		}
		return true;

	}
	public def exec(stmt:String)
	{
		// A special symbol table directive, currently not in use
		// perhaps I will make a private and public symt later 
		// Right now, internal variables start with underscore 
		// which our grammar does not allow in variable names
		if(stmt.indexOf("symt") != -1) {
			return;
		}
		if(stmt.indexOf("print") != -1) {
			val oper = stmt.substring(stmt.lastIndexOf(' '),
							stmt.length()).trim();
			if(symt.containsKey(oper)) {
				Console.OUT.println(oper+" = ");
				Console.OUT.println(symt.get(oper).value);
			} else { 
				Console.OUT.println("Variable "+oper+" undefined.");
			}
			return;
		}

		val eq:Int = stmt.indexOf('=');
		val variable:String = stmt.substring(0,eq).trim();

		if(stmt.indexOf('[') != -1) {
			val oper = stmt.substring(stmt.lastIndexOf('['),stmt.length());
			symt.put(variable, new Matrix(oper));
		}
		else if(stmt.indexOf('{') != -1) {
			val oper = stmt.substring(stmt.lastIndexOf('{'),stmt.length());
			symt.put(variable, new Matrix(oper));
		}
		else if((stmt.indexOf(".*") != -1)||
			(stmt.indexOf("./") != -1)||
			(stmt.indexOf(".\\") != -1)||
			(stmt.indexOf(".^") != -1)) {
			val op = stmt.indexOf('.');
			val sop = stmt.substring(op,op+2);
			val oper1 = stmt.substring(eq+1,op-1).trim();
			val oper2 = stmt.substring(op+2,stmt.length()).trim();
			var o1:Matrix = null;
			var o2:Matrix = null;
			if(Parser.isNumber(oper1)) o1 = new Matrix(Double.parse(oper1));
			if(Parser.isNumber(oper2)) o2 = new Matrix(Double.parse(oper2));
			if(symt.containsKey(oper1)) o1 = symt.get(oper1).value;
			if(symt.containsKey(oper2)) o2 = symt.get(oper2).value;

			if(o1 != null && o2 != null) {
				if(sop.equals(".*"))
					symt.put(variable,eng.times(o1,o2));
				if(sop.equals("./"))
					symt.put(variable,eng.rdivide(o1,o2));
				if(sop.equals(".^"))
					symt.put(variable,eng.power(o1,o2));
				if(sop.equals(".\\"))
					symt.put(variable,eng.ldivide(o1,o2));
			} else {
				Console.OUT.println("Invalid operands to arraymult.");
			}
		}
		else if((stmt.indexOf('+') != -1)||
			(stmt.indexOf('-') != -1)||
			(stmt.indexOf('*') != -1)|| 
			(stmt.indexOf('\\') != -1)|| 
			(stmt.indexOf('/') != -1)||
			(stmt.indexOf('^') != -1)) {
			val op = stmt.lastIndexOf(' ') - 1;
			val oper1 = stmt.substring(eq+1,op).trim();
			val oper2 = stmt.substring(op+1,stmt.length()).trim();
			var o1:Matrix = null;
			var o2:Matrix = null;
			if(Parser.isNumber(oper1)) o1 = new Matrix(Double.parse(oper1));
			if(Parser.isNumber(oper2)) o2 = new Matrix(Double.parse(oper2));
			if(symt.containsKey(oper1)) o1 = symt.get(oper1).value;
			if(symt.containsKey(oper2)) o2 = symt.get(oper2).value;

			if(o1 != null && o2 != null) {
				if(stmt.charAt(op).equals('+')) symt.put(variable,eng.plus(o1,o2));
				if(stmt.charAt(op).equals('-')) symt.put(variable,eng.minus(o1,o2));
				if(stmt.charAt(op).equals('*')) symt.put(variable,eng.mtimes(o1,o2));
				if(stmt.charAt(op).equals('/')) symt.put(variable,eng.mrdivide(o1,o2));
				if(stmt.charAt(op).equals('\\')) symt.put(variable,eng.mldivide(o1,o2));
				if(stmt.charAt(op).equals('^')) symt.put(variable,eng.mpower(o1,o2));
			} else {
				Console.OUT.println("Invalid rands to "+op+": "+oper1+","+oper2);
			}
		}
		else if((stmt.indexOf('\'') != -1)||
			(stmt.indexOf(".\'") != -1)) {
			var op:Int = stmt.indexOf('.');
			if(op == -1) op = stmt.indexOf('\'');
			val oper = stmt.substring(stmt.lastIndexOf(' '),op).trim();
			if(Parser.isNumber(oper)) {
				symt.put(variable,new Matrix(Double.parse(oper)));	
			} else {
				symt.put(variable,eng.transpose(symt.get(oper).value));
			}
		}
		else {
			val oper = stmt.substring(stmt.lastIndexOf(' '),
						  stmt.length()).trim();
			if(Parser.isNumber(oper)) {
				symt.put(variable,new Matrix(Double.parse(oper)));
			} else if(symt.containsKey(oper)) {
				symt.put(variable,symt.get(oper).value);
			} else {
			throw new ParserException("UNSUPPORTED OPERATION");
			}
		}
	}
}
