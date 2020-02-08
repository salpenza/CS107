package edu.sbcc.cs107;

/**
 * @author Salvatore Penza CS 107: Disassembler Project
 *
 *         This class is used to model a half-word of an object file. Each
 *         half-word must have an address as well as a data value that can be
 *         disassembled into mnemonics and optional operands.
 * 
 *         Note that the half-word is 16 bits but we are using a Java int which
 *         is typically 32 bits. Be sure to take that into account when working
 *         with it.
 *
 */
public class Halfword {
	private int address;
	private int data;


	/**
	 * Constructor for a halfword.
	 * 
	 * @param address
	 * @param data
	 */
	public Halfword(int address, int data) {
		this.address = address;
		this.data = data;
	}


	/**
	 * toString method.
	 * 
	 * The format for the halfword is a hex value 8 characters wide (address), a
	 * single space, and a hex value four characters wide (data).
	 * 
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() { // creates proper format
		StringBuilder sb = new StringBuilder("0000"); // use string builder to create strings
		String Data = Integer.toHexString(data);
		String Address = Integer.toHexString(address); // attach data and address
		int datalength = Data.length();
		int addresslength = Address.length();
		// int i = 0;
		// while (i < 4 - addresslength) {
		// sb.append("0");
		// sb.append(Address);
		// sb.append(" ");
		// i++;
		// }
		for (int i = 0; i < 4 - addresslength; i++) // fill address
			sb.append("0");
		sb.append(Address);
		sb.append(" ");
		// while (i < 4 - datalength) {
		// sb.append("0");
		// sb.append(Data);
		// i++;
		// }

		for (int i = 0; i < 4 - datalength; i++) // fill data
			sb.append("0");
		sb.append(Data);
		return sb.toString().toUpperCase();
	}


	/**
	 * Get the address of the half-word.
	 * 
	 * @return
	 */
	public int getAddress() {
		return this.address;
	}


	/**
	 * Get the data of the half-word.
	 * 
	 * @return
	 */
	public int getData() {
		return this.data;

	}

}
