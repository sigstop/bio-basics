-module(bio_util).

-compile(export_all).

readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    get_all_lines(Device, []).
 
get_all_lines(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), Accum;
        Line -> get_all_lines(Device, Accum ++ [Line])
    end.

test_pcount()->
    [Header,RawInput|Rest]= readlines("../data/dataset_2_6.txt"),
    Input = lists:subtract(RawInput,"\n"),
    pattern_count(Input,"ATA").

pattern_count(Input,Pattern) when length(Input) >= length(Pattern) ->
    InLen = length(Input),
    BinIn = binary:list_to_bin(Input),
    PatLen = length(Pattern),
    BinPat = binary:list_to_bin(Pattern),
    StopPos = InLen - PatLen,
    StartPos = 0,
%%  binary:matches(BinIn,BinPat,[]).
    bin_pcount(BinIn,BinPat,PatLen,StartPos,StopPos - StartPos,0).

bin_pcount(BinIn,BinPat,PatLen,CurPos,-1,Count)->
    Count;
bin_pcount(BinIn,BinPat,PatLen,CurPos,Left,Count) ->
    InPart = binary:part(BinIn,CurPos,PatLen),
    case binary:match(InPart,BinPat) of
	nomatch ->
	    bin_pcount(BinIn,BinPat,PatLen,CurPos+1,Left-1,Count);
	_ -> 	    
	    bin_pcount(BinIn,BinPat,PatLen,CurPos+1,Left-1,Count+1)
    end.
    

	    
    
    
    

