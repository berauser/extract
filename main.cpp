
#include <iostream>

const char my_data[] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};

int main()
{

	for(int i = 0; i < sizeof(my_data); ++i)
	{
		std::cout << std::dec << i << " -> " << std::hex << my_data[i] << std::endl;
	}

	return 0;
}