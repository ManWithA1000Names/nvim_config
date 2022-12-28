syntax keyword DEFINITION mut type interface where implement # in step match using import export default from if else as catch enum
syntax keyword OPERATION break continue defer return for 
syntax keyword Type int char byte uint number float i8 i16 i32 i64 u8 u16 u32 u64 f32 f64 str string bool *int *uint *number *float *i8 *i16 *i32 *i64 *u8 *u16 *u32 *u64 *f32 *f64 *str *string *bool *byte *char Option Result None not and or
syntax keyword Variable std

syntax match Variable /\w[^\s\(\).:;{},\[\]]*/
syntax match Variable /^\w*:/he=e-1
syntax match Variable /  *\w*:/he=e-1
syntax match Type /->\s*[^;={}]*/hs=s+3
syntax match Type /<\w*[<>]/hs=s+1,he=e-1
syntax match Type /[^:]:[^=;}:,\(\)]*/hs=s+2
syntax match String /"[^"]*"/
syntax match DEFINITION /@\w*/

syntax region Comment start="//" end="\n"
syntax region Comment start="/\*" end="\*/"

hi Type           ctermfg=Cyan     guifg=#27bbf5
hi DEFINITION     ctermfg=Magenta  guifg=#AC8EE3
hi OPERATION      ctermfg=Magenta  guifg=#AC8EE3
hi Comment        ctermfg=Gray     guifg=#525252
hi Variable       ctermfg=Blue     guifg=#7AA2F7
hi White          ctermfg=White    guifg=#FFFFFF
hi String         ctermfg=Green    guifg=#9ECE6A
