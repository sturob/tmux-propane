#!/bin/awk

BEGIN { total=0; linecount=0; } 
{
    total += $1;
    lines[++linecount] = $1;
} 
END { 
    avg = int(total/linecount);
    for(i = 1; i <= linecount; ++i) {
        lines[i] = avg;
    }

    remainder = total - avg * linecount;
    for(i = 1; i <= remainder; ++i) {
        ++lines[i];
    }

    for(i = 1; i <= linecount; ++i) {
        print lines[i];
    }
}

