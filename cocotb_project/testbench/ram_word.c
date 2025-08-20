// SPDX-FileCopyrightText: 2023 Efabless Corporation

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//      http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#define USER_ADDR_SPACE_C_HEADER_FILE  // TODO disable using the other file until tag is updated and https://github.com/efabless/caravel_mgmt_soc_litex/pull/137 is merged

#include <firmware_apis.h>
#include <custom_user_space.h>
#include <ram_info.h>

void main(){
    // Enable management GPIOs as output to use as indicators for finishing configuration  
    GPIOs_configure(32, GPIO_MODE_MGMT_STD_OUTPUT);
    GPIOs_configure(33, GPIO_MODE_MGMT_STD_OUTPUT);
    GPIOs_loadConfigs();
    User_enableIF(1);
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    GPIOs_writeHigh(0b10);

    // Define control variables
    volatile int shifting;
    volatile int data_used;
    int start_address[3] = {0, (RAM_NUM_WORDS * 4 / 10), (RAM_NUM_WORDS * 9 / 10)};
    int end_address[3] = {(RAM_NUM_WORDS / 10), (RAM_NUM_WORDS * 5 / 10), RAM_NUM_WORDS};

    // Scenario 1: Write 32 entries, Read 20
    perform_scenario(32, 20, 3300);

    // Scenario 2: Write 10 entries, Read 20
    perform_scenario(10, 20, 1100);

    // Scenario 3: Write 30 entries, Read 32
    perform_scenario(30, 32, 2550);

    // Scenario 4: Write 10 entries, Read 8
    perform_scenario(10, 8, 1500);

    // Scenario 5: Reset mid-operation
    ManagmentGpio_write(0); // Reset logic
    GPIOs_writeHigh(0b01);  // Simulate failure
    ManagmentGpio_write(1); // Finish the test

    // Scenario 6: Write 10 entries, Read 7
    perform_scenario(10, 7, 900);

    // End of test
    ManagmentGpio_write(1); // Finish test
}

void wishbone_write_mul(int count) {
    for (int i = 0; i < count; i++) {
        int row_addr = rand() % 32;
        int col_addr = rand() % 32;
        int rand_data = rand() % 256;

        // Compose data word
        uint32_t composed_data = (0b00 << 30) | (row_addr << 25) | (col_addr << 20) | (0b0000 << 16) | (0x00 << 8) | rand_data;

        // Simulate Wishbone write
        USER_writeWord(composed_data, row_addr);  // Simulate write to the address

        // Output write details
        printf("[WRITE] row=%d, col=%d, data=0x%02X\n", row_addr, col_addr, rand_data);
    }
}

void wishbone_read_mul(int count) {
    for (int i = 0; i < count; i++) {
        int row_addr = rand() % 32;
        int col_addr = rand() % 32;

        // Simulate Wishbone read
        uint32_t data_out = USER_readWord(row_addr);

        // Output read details
        printf("[READ] data_out = 0x%08X @ row_addr=%d\n", data_out, row_addr);
    }
}

void perform_scenario(int write_count, int read_count, int delay) {
    // Perform write operations
    wishbone_write_mul(write_count);

    // Simulate delay (Placeholder for real-time wait)
    printf("Delay: %d ns\n", delay);

    // Perform read operations
    wishbone_read_mul(read_count);
}
