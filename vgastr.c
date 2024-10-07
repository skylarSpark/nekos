// Chris @ Oct. 7 2024
// display string using VGABIOS

void _strwrite(char* string)
{
    char* p_strdst = (char*)(0xb8000); // address pointed to video memory
    while (*string)
    {
        *p_strdst = *string++;
        p_strdst += 2;
    }
    return;
}

void printf(char* fmt, ...)
{
    _strwrite(fmt);
    return;
}