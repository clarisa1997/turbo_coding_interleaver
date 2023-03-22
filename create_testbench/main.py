if __name__ == '__main__':
    type = input("Insert the type of inputs: [bin or hex]?\n")
    howManyDigits = int(input("How many digits?\n"))
    input_file = input("Insert the input file name (.txt file)\n")
    input_file_name = "./" + input_file + ".txt"
    output_file = input("Insert the testbench file name: (without file extension)\n")
    output_file_name = output_file + ".vhd"
    howMany = howManyDigits
    inputFile = open(input_file_name, "r")
    input_bits = inputFile.read()
    binary_string = str(input_bits)
    if type == "hex":
        integer = int(input_bits, 16)
        form = "0>" + str(howManyDigits) + "b"
        binary_string = format(integer, form)
        howMany = int(howManyDigits*4)
    print(binary_string)
    print(howMany)

    first_lines = [ "-- Librerie utilizzate",
                    "library IEEE;",
                    "use IEEE.std_logic_1164.all;",

                    "entity " + output_file + " is",
                    "end " + output_file + ";",

                    "-- Dichiarazione dell'entità",

                    "architecture interleaver_test of " + output_file + " is",
                    "	component interleaver",
                    "   generic(Nbit: POSITIVE := " + str(howMany) + ");",
                    "		port (",
                    "			clock		: in std_logic;				",
                    "			reset	    : in std_logic;			    ",
                    "			bit_in		: in std_logic;	            ",
                    "			bit_out 	: out std_logic	            ",
                    "			);",
                    "	end component;",

                    "-----------------------------------------------------",

                    "   --CONSTANT",
                    "	CONSTANT clock_period : TIME := 100 ns;",
                    "	CONSTANT len : INTEGER := " + str((howMany*2)+3) + ";",

                    "	--INPUT SIGNALS",
                    "	SIGNAL clock_tb : std_logic := '0';",
                    "	SIGNAL reset_tb : std_logic := '1';",
                    "	SIGNAL bit_in_tb : std_logic := '0';",
                    "",
                    "",
                    "	--OUTPUT SIGNALS",
                    "	SIGNAL bit_out_tb : std_logic := '0';",
                    "",
                    "	SIGNAL testing: Boolean :=True;",
                    "",
                    "	SIGNAL count: INTEGER:= 0;",
                    "",
                    "   SIGNAL count_reset: INTEGER:= 0;",
                    "",
                    "	BEGIN",
                    "		I: interleaver",
                    "       generic map(Nbit => "+ str(howMany) + ")",
                    "       PORT MAP",
                    "           (clock => clock_tb, reset => reset_tb, bit_in => bit_in_tb, bit_out =>bit_out_tb);",
                    "",
                    "   --Generates clk",
                    "	clock_tb <=NOT clock_tb AFTER clock_period/2 WHEN testing ELSE '0';",
                    "   --reset_tb <= '0' after 2*clock_Period;",
                    "",
                    "    --Runs simulation for len cycles",
                    "    proc_test: process(clock_tb, reset_tb)",
                    "",
                    "    begin",
                    "",
                    "        if(reset_tb = '1') then",
                    "				bit_in_tb <= 'Z';",
                    "               count <= 0;",
                    "               if rising_edge(clock_tb) and (count_reset < 3) then",
                    "                   count_reset <= count_reset +1;",
                    "               elsif rising_edge(clock_tb) and (count_reset >= 3) then",
                    "                   reset_tb <= '0';",
                    "               end if;",
                    "",
                    "       elsif rising_edge(clock_tb) then",
                    "           CASE count IS"
                    ]
    for i in range(howMany):
        first_lines.append("                WHEN " + str(i) + " => " + "bit_in_tb <= '" + str(binary_string[i]) + "';")

    last_lines = [  "               WHEN	OTHERS	=>	NULL;",
                    "           END CASE;",
                    "           if count >= " + str(howMany) + " then",
                    "               bit_in_tb <= 'Z';",
                    "           end if;",
                    "           if (count > len) then ",
                    "               reset_tb <= '1';",
                    "               testing <= false;      -- fine test",
                    "           end if;",
                    "           count <= count + 1;",
                    "       end if;",
                    "",
                    "",
                    "end process proc_test;",
                    "",
                    "end interleaver_test;"
                    ]

    outF = open(output_file_name, "w")
    for element in first_lines:
        outF.write(element + "\n")
    for element in last_lines:
        outF.write(element + "\n")
    outF.close()
