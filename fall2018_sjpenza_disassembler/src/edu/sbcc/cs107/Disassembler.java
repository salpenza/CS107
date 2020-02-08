package edu.sbcc.cs107;

/**
 * @author Salvatore Penza CS 107: Disassembler Project
 * 
 *         This code implements the disassembler as well as pulling apart the
 *         Hex file. The hex file format is documented at
 *         http://www.keil.com/support/docs/1584/
 */
public class Disassembler {

	/**
	 * Extracts the register operand from a halfword.
	 * 
	 * The register operand (e.g. r0) is used by many mnemonics and is embedded in
	 * the data halfword. It position is specified by the least significant bit and
	 * most significant bit. This value is extracted and concatenated with "r" to
	 * give us the desired register.
	 * 
	 * @param hw
	 *            Halfword that contains the machine code data.
	 * @param lsBitPosition
	 *            Encoded register value (LSB)
	 * @param msBitPosition
	 *            Encoded register value (MSB)
	 * @return Register field designation (e.g. r1)
	 */

	public String convert(Halfword hw) { // needed in other methods
		int data = hw.getData();
		String bindata = Integer.toBinaryString(data);
		StringBuilder sb = new StringBuilder("0000000000000000"); // build new strings
		int i = 0;
		while (i < bindata.length()) {
			sb.setCharAt(16 - bindata.length() + i, bindata.charAt(i));
			i++;
		}
		return sb.toString();
	}


	public String getRegister(Halfword hw, int lsBitPosition, int msBitPosition) {
		String data = convert(hw);
		String register;
		switch (lsBitPosition) {
		case '0':
			register = data.substring(data.length() - msBitPosition - 1);
		default:
			register = data.substring(data.length() - msBitPosition - 1, data.length() - lsBitPosition);
			return "r" + Integer.parseInt(register, 2);
		}

	}


	/**
	 * Extracts the immediate operand from a halfword.
	 * 
	 * Same as the getRegister function but returns the embedded immediate value
	 * (e.g. #4).
	 * 
	 * @param hw
	 *            Halfword that contains the machine code data.
	 * @param lsBitPosition
	 *            Encoded immediate value (LSB)
	 * @param msBitPosition
	 *            Encoded immediate value (MSB)
	 * @return Immediate field designation (e.g. #12)
	 */
	public String getImmediate(Halfword hw, int lsBitPosition, int msBitPosition) {
		String data = convert(hw);
		String register;
		switch (lsBitPosition) {
		case '0':
			register = data.substring(data.length() - msBitPosition - 1);
		default:
			register = data.substring(data.length() - msBitPosition - 1, data.length() - lsBitPosition);
			return "#" + Integer.parseInt(register, 2);
		}
	}


	/**
	 * Returns a formatted string consisting of the Mnemonic and Operands for the
	 * given halfword.
	 * 
	 * The halfword is decoded into its corresponding mnemonic and any optional
	 * operands. The return value is a formatted string with an 8 character wide
	 * field for the mnemonic (left justified) a single space and then any operands.
	 * 
	 * @param hw
	 *            Halfword that contains the machine code data.
	 * @return Formatted string containing the mnemonic and any operands.
	 */

	public String dissassembleToString(Halfword hw) { // printer method that returns converted strings that follow the
														// correct format
		String dataInBinPost = convert(hw);
		// conversions
		if (dataInBinPost.substring(0, 5).equals("11100")) {
			String imm11 = getImmediate(hw, 0, 10);
			char returnChar = (char) Integer.parseInt(imm11.substring(1));
			return String.format("%-8s %s", "REV", returnChar);
		} else if (dataInBinPost.substring(0, 7).equals("0001110")) {
			String Rn = getRegister(hw, 3, 5);
			String Rd = getRegister(hw, 0, 2);
			String imm3 = getImmediate(hw, 6, 8);
			return String.format("%-8s %s, %s, %s", "ADDS", Rd, Rn, imm3);
		} else if (dataInBinPost.substring(0, 10).equals("0100001011")) {
			String Rn = getRegister(hw, 0, 2);
			String Rm = getRegister(hw, 3, 5);
			return String.format("%-8s %s, %s", "CMN", Rn, Rm);
		} else if (dataInBinPost.substring(0, 10).equals("0100000101")) {
			String Rdn = getRegister(hw, 0, 2);
			String Rm = getRegister(hw, 3, 5);
			return String.format("%-8s %s, %s", "ADCS", Rdn, Rm);
		} else if (dataInBinPost.substring(0, 5).equals("00100")) {
			String Rd = getRegister(hw, 8, 10);
			String imm8 = getImmediate(hw, 0, 7);
			return String.format("%-8s %s, %s", "MOVS", Rd, imm8);
		} else if (dataInBinPost.substring(0, 7).equals("0101011")) {
			String Rn = getRegister(hw, 3, 5);
			String Rm = getRegister(hw, 6, 8);
			String Rt = getRegister(hw, 0, 2);
			return String.format("%-8s %s, [%s, %s]", "LDRSB", Rt, Rn, Rm);
		} else if (dataInBinPost.substring(0, 10).equals("0000000000")) {
			String Rd = getRegister(hw, 0, 2);
			String Rm = getRegister(hw, 3, 5);
			return String.format("%-8s %s, %s", "MOVS", Rd, Rm);
		} else if (dataInBinPost.substring(0, 10).equals("1011101000")) {
			String Rd = getRegister(hw, 0, 2);
			String Rm = getRegister(hw, 3, 5);
			return String.format("%-8s %s, %s", "REV", Rd, Rm);
		}
		// else if (dataInBinPost.substring(0, 9).equals("0101111")) {
		// String Rn = getRegister(hw, 0, 5);
		// String Rm = getRegister(hw, 6, 8);
		// return String.format("%-8s %s, [%s, %s]", "LRSB", Rn, Rm);
		// }else if (dataInBinPost.substring(0, 11).equals("10101011011")) {
		// String Rn = getRegister(hw, 0, 6);
		// String Rt = getRegister(hw, 7, 11);
		// return String.format("%-8s %s, %s", "CMN", Rn, Rm);
		// }
		// breakgnjngtf
		return null;
	}

}