syntax keyword DEFINITION let const function struct type interface end if for async await else elif switch case default in enum then do static stack heap map struct fu
syntax keyword BUILT_IN tostring tonumber toboolean print eprint malloc calloc realloc free
syntax keyword SPECIAL_VALUE true false null
syntax keyword OPERATION break continue include defer return
syntax keyword Type int char byte uint number float i8 i16 i32 i64 u8 u16 u32 u64 f32 f64 str string bool *int *uint *number *float *i8 *i16 *i32 *i64 *u8 *u16 *u32 *u64 *f32 *f64 *str *string *bool *byte *char Option Result fu
syntax keyword STD from

syntax match Number /[0-9]*/
syntax match Number /0x[a-fA-F0-9]*/
syntax match Number /0b[01]*/
syntax match Number /0o[0-7]*/
syntax match String /"[^"]*"/
syntax match String /b"[^"]*"/
syntax match String /f"[^"]*"/
syntax match STD /@[a-zA-Z]*/
syntax match OPERATORS /[+-/\\*^&!|=<>:]/
syntax region Comment start="//" end="\n"
syntax region Comment start="/\*" end="\*/"

hi DEFINITION     ctermfg=Magenta  guifg=#AC8EE3
hi STD            ctermfg=Red      guifg=#199e15
hi OPERATION      ctermfg=Magenta  guifg=#AC8EE3
hi Type           ctermfg=Cyan     guifg=#27bbf5
hi Comment        ctermfg=Gray     guifg=#525252
hi String         ctermfg=Green    guifg=#9ECE6A
hi SPECIAL_VALUE  ctermfg=Red      guifg=#de6d0b
hi Number         ctermfg=Blue     guifg=#0060bf
hi OPERATORS      ctermfg=Blue     guifg=#96eeff
hi FunctionName   ctermfg=Blue     guifg=#7AA2F7
hi BUILT_IN       ctermfg=Blue     guifg=#36a1ff
