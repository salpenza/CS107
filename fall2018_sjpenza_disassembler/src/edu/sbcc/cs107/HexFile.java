package edu.sbcc.cs107;

import java.io.*;
import java.nio.file.*;
import java.util.ArrayList;

/**
 * @author Salvatore Penza CS 107: Disassembler Project
 *
 *         This code implements working with a Hex file. The hex file format is
 *         documented at http://www.keil.com/support/docs/1584/
 */
public class HexFile {
	/**
	 * This is where you load the hex file. By making it an ArrayList you can easily
	 * traverse it in order.
	 */
	private ArrayList<String> hexFile = null; // variables
	private ArrayList<Halfword> halfwords = new ArrayList<Halfword>();
	private int data, address, recordType, line, index = 0;


	/**
	 * Constructor that loads the .hex file.
	 * 
	 * @param hexFileName
	 * @throws FileNotFoundException
	 */

	public HexFile(String hexFileName) throws FileNotFoundException { // read file into array
		try {
			hexFile = (ArrayList<String>) Files.readAllLines(Paths.get(hexFileName));
		} catch (IOException i) {
			i.printStackTrace();
		}
	}


	public ArrayList<Halfword> getHalfword(String line) { // array edit
		ArrayList<Halfword> halfwords = new ArrayList<Halfword>();
		int address = getAddressOfRecord(line);
		int numData = getDataBytesOfRecord(line);
		String dataStr = line.substring(9, 9 + numData * 2);
		int i = 0;
		while (i < dataStr.length()) {
			String reverse = dataStr.substring(i, i + 4);
			String right = reverse.substring(2);
			String left = reverse.substring(0, 2);
			int dataInHex = Integer.parseInt(right + left, 16);
			halfwords.add(new Halfword(address + i / 2, dataInHex));
			i += 4;
		}
		return halfwords;
	}


	public void create() { // getter and filler
		// while (line < hexFile.size()) {
		// if (getRecordType(hexFile.get(line)) != 0)
		// continue;
		// String hexline = hexFile.get(line);
		// ArrayList<Halfword> halfWord = getHalfword(hexline);
		// halfwords.addAll(halfWord);
		// line++;
		// }
		// if(i=0)
		for (line++; line < hexFile.size(); line++) {
			if (getRecordType(hexFile.get(line)) != 0)
				continue;
			String hexline = hexFile.get(line);
			ArrayList<Halfword> halfWord = getHalfword(hexline);
			halfwords.addAll(halfWord);
		}
	}


	/**
	 * Pulls the length of the data bytes from an individual record.
	 * 
	 * This extracts the length of the data byte field from an individual hex
	 * record. This is referred to as LL->Record Length in the documentation.
	 * 
	 * @param Hex
	 *            file record (one line).
	 * @return record length.
	 */
	public int getDataBytesOfRecord(String record) {
		data = (int) Long.parseLong(record.substring(1, 3), 16);
		return this.data;
	}


	/**
	 * Get the starting address of the data bytes.
	 * 
	 * Extracts the starting address for the data. This tells you where the data
	 * bytes start and are referred to as AAAA->Address in the documentation.
	 * 
	 * @param Hex
	 *            file record (one line).
	 * @return Starting address of where the data bytes go.
	 */
	public int getAddressOfRecord(String record) {
		address = (int) Long.parseLong(record.substring(3, 7), 16);
		return address;
	}


	/**
	 * Gets the record type.
	 * 
	 * The record type tells you what the record can do and determines what happens
	 * to the data in the data field. This is referred to as DD->Data in the
	 * documentation.
	 * 
	 * @param Hex
	 *            file record (one line).
	 * @return Record type.
	 */
	public int getRecordType(String record) {
		recordType = (int) Long.parseLong(record.substring(7, 9), 16);
		return recordType;
	}


	/**
	 * Returns the next halfword data byte.
	 * 
	 * This function will extract the next halfword from the Hex file. By repeatedly
	 * calling this function it will look like we are getting a series of halfwords.
	 * Behind the scenes we must parse the HEX file so that we are extracting the
	 * data from the data files as well as indicating the correct address. This
	 * requires us to handle the various record types. Some record types can effect
	 * the address only. These need to be processed and skipped. Only data from
	 * recordType 0 will result in something returned. When finished processing null
	 * is returned.
	 * 
	 * @return Next halfword.
	 */

	public Halfword getNextHalfword() { // get next halfword from hex file
		// switch (index) {
		// case (0):
		// create();
		// break;
		// case (halfwords.size()):
		// return halfwords.get(index++);
		// default:
		// return null;
		if (index == 0) {
			create();
		}
		if (index < halfwords.size())
			return halfwords.get(index++);
		else
			return null;
	}

}