Program labirint;
uses crt,graph,mouse;

const
UP_ARROW            = #72;  DOWN_ARROW          = #80;
LEFT_ARROW          = #75;  RIGHT_ARROW         = #77;
ENTER               = #13;
SPACEBAR         	= #32;   ESCAPE              = #27;
storyfolder:array[1..4] of string=('multi\story\story.txt','multi\story\story2.txt',
                                   'multi\story\story3.txt','multi\story\story4.txt');
meniutype:array[1..5] of string=('     Play Game     ','     Load Game     ','      Options      ','      Extras       ',
                                 '       Exit        ');
extrastype:array[1..4] of string=('        Help       ','     High Scores   ','       Credits     ','        Exit       ');
optionstype:array[1..4] of string=('       Music       ','      Stopwatch    ','     Difficulty    ','        Exit       ');
TYPE vft=array[1..20] of string;
TYPE boss=array[1..10] of string[20];
TYPE patru=0..4;
TYPE pointype=0..100000;
TYPE okcioc=RECORD
     ok:boolean;
     okx,oky:integer;
     end;
TYPE highs=RECORD
     name:string[7];
     score:pointype;
     end;
TYPE leveltype=RECORD
     lvlul,open:integer;
     end;
TYPE lvlvec=array[1..25] of leveltype;
TYPE highvec=array[1..5] of highs;
var i,j,x,y,height,hight,long,level,aix,aiy,lvltype,option:integer;
    longboss,bx,by,heightb,hightb,latime,startx,starty,nrf,nrmf,maxlvl:integer;
    lifes,ciocanel:patru;
    time:longint;
    points:pointype;
    bos:boss;
    ch:char;
    f:text;
    highscore:highvec;
    instruction,v,stages:vft;
    continue,exiti,muzica,timesboolean,final,shigh:boolean;
    okcio:okcioc;
    mapname,monstercolor,bar,nextmap:string;

procedure salveaza_high(x:pointype);
var i,j:integer;
    f:text;
begin
textcolor(white);
i:=4;
if x>highscore[5].score then
   while (x>highscore[i+1].score) and (i>0) do begin dec(i); end;
for j:=5 downto i+1 do highscore[j]:=highscore[j-1];
gotoxy(28,18);write('Please insert your name !');
gotoxy(30,20);write('ษออออออออออออออออออออป');
gotoxy(30,22);write('ศออออออออออออออออออออผ');
gotoxy(30,21);write('บ                    บ');
gotoxy(35,21);read(highscore[j].name);
highscore[j].name:=' '+highscore[j].name;
highscore[j].score:=x;
shigh:=false;
ASSIGN(f,'multi\highscores.txt');rewrite(f);
for i:=1 to 5 do writeln(f,highscore[i].score,highscore[i].name);
close(f);
end;

procedure citire_informatii_joc(var x:vft;var nr:integer);
var g:text;
    i:integer;
begin
ASSIGN(g,'gameinfo.txt');reset(g);
readln(g,nr);
for i:=1 to nr do readln(g,x[i]);
close(g);
ASSIGN(g,'multi\savegame.txt');reset(g);
readln(g,level,points);
close(g);
end;

procedure citire_highs;
var i:integer;
    f:text;
begin
ASSIGN(f,'multi\highscores.txt');reset(f);
for i:=1 to 5 do readln(f,highscore[i].score,highscore[i].name);
close(f);
end;

procedure semnatura(x,y:integer);
begin
gotoxy(x,y);
write('(C) Maritim Software');
end;

procedure dispare_cursor(x,y:integer);
begin
textcolor(black);
gotoxy(x,y);
end;

procedure meniu(var x:integer);
begin
x:=1;
textbackground(black);
repeat
clrscr;
textcolor(white);
semnatura(60,24);
gotoxy(30,4);write('ฑฑฑฑ');
gotoxy(30,5);write('ฑ         ''  ฑฑ ฑฑ');
gotoxy(30,6);write('ฑฑฑฑENTAUR S ฑ ฑ ฑ');
gotoxy(30,7);write('             ฑ   ฑAZE');
gotoxy(30,11);write('ษออออออออออออออออออออป');
gotoxy(30,17);write('ศออออออออออออออออออออผ');
gotoxy(30,12);write('บ',meniutype[1],' บ');
gotoxy(30,13);write('บ',meniutype[2],' บ');
gotoxy(30,14);write('บ',meniutype[3],' บ');
gotoxy(30,15);write('บ',meniutype[4],' บ');
gotoxy(30,16);write('บ',meniutype[5],' บ');
textbackground(blue);
gotoxy(31,11+x);write(meniutype[x]);
textbackground(black);
dispare_cursor(80,25);
if shigh then salveaza_high(points);
ch:=readkey;
if (ch=UP_ARROW) and (x>1) then dec(x)
   else if (ch=DOWN_ARROW) and (x<5) then inc(x);
until (ch=ENTER) or (ch=ESCAPE);
lifes:=3;
end;

procedure timpul_fade(x,y:integer);
begin
textbackground(y);
clrscr;
dispare_cursor(80,25);
delay(x*100);
end;

procedure sterge_text;
var i:integer;
begin
textbackground(black);
textcolor(green);
for i:=1 to latime-3 do begin gotoxy(height+i,hight+long+2);write(' '); end;
end;

procedure afisare_high;
begin
textbackground(black);
textcolor(white);
clrscr;
gotoxy(34,7);write('ฑ ฑ');
gotoxy(34,8);write('ฑฑฑ');
gotoxy(34,9);write('ฑ ฑIGH SCORES !');
gotoxy(30,11);write('ษออออออออออออออออออออป');
gotoxy(30,17);write('ศออออออออออออออออออออผ');
gotoxy(30,12);write('บ',highscore[1].name:9,highscore[1].score:7,'    บ');
gotoxy(30,13);write('บ',highscore[2].name:9,highscore[2].score:7,'    บ');
gotoxy(30,14);write('บ',highscore[3].name:9,highscore[3].score:7,'    บ');
gotoxy(30,15);write('บ',highscore[4].name:9,highscore[4].score:7,'    บ');
gotoxy(30,16);write('บ',highscore[5].name:9,highscore[5].score:7,'    บ');
dispare_cursor(80,25);
ch:=readkey;
ch:=SPACEBAR;
end;

procedure credits;
begin
textbackground(black);
textcolor(white);
clrscr;
gotoxy(17,6);write('ษออออออออออออออออออออออออออออออออออออออออออออออป');
gotoxy(17,7);write('บ                                              บ');
gotoxy(17,8);write('บ            Software developed by             บ');
gotoxy(17,9);write('บ            Lambru Andrei Cristian            บ');
gotoxy(17,10);write('บ                                              บ');
gotoxy(17,11);write('บ         A romanian 100% production !         บ');
gotoxy(17,12);write('บ                                              บ');
gotoxy(17,13);write('บ               Only for fun !                 บ');
gotoxy(17,14);write('บ                                              บ');
gotoxy(17,15);write('บ                  Contact :                   บ');
gotoxy(17,16);write('บ           cristi_lambru@yahoo.com            บ');
gotoxy(17,17);write('บ                                              บ');
gotoxy(17,18);write('ศออออออออออออออออออออออออออออออออออออออออออออออผ');
dispare_cursor(80,25);
delay(2000);
ch:=readkey;
ch:=SPACEBAR;
end;

procedure textul(tex:string; x,y:integer);
var f:text;
    a:string;
    nr:integer;
begin
textcolor(white);
clrscr;
nr:=0;
ASSIGN(f,tex);reset(f);
while not eof(f) do begin
      readln(f,a);
      gotoxy(x,y+nr);write(a);
      inc(nr);
      end;
dispare_cursor(80,25);
close(f);
end;

procedure help(x:char);
var nrtext:patru;
begin
nrtext:=1;
if ch=ENTER then begin
   timpul_fade(5,0);
   repeat
   textul(storyfolder[nrtext],17,4);
   inc(nrtext);
   repeat
   ch:=readkey;
   until ch in [SPACEBAR,ENTER,ESCAPE];
   until nrtext=5;
   end;
end;

procedure settings(message1,message2:string; var seter:boolean);
var i:integer;
begin
if seter then i:=1
   else if not(seter) then i:=2;
repeat
textbackground(black);
textcolor(white);
gotoxy(30,18);write('ษออออออออออออออออออออป');
gotoxy(30,21);write('ศออออออออออออออออออออผ');
gotoxy(30,19);write('บ',message1,' บ');
gotoxy(30,20);write('บ',message2,' บ');
textbackground(blue);
if i=1 then begin gotoxy(31,19);write(message1);end
       else begin gotoxy(31,20);write(message2);end;
repeat
dispare_cursor(80,25);
ch:=readkey;
until ch in [UP_ARROW,DOWN_ARROW,ENTER,ESCAPE];
if (ch=UP_ARROW) and (i=2) then dec(i)
   else if (ch=DOWN_ARROW) and (i=1) then inc(i);
until ch in [ENTER,ESCAPE];
if (ch=ENTER) and (i=1) then seter:=true
   else if (ch=ENTER) and (i=2) then seter:=false;
gotoxy(1,18);writeln;
writeln;
writeln;writeln;
dispare_cursor(80,25);
ch:=SPACEBAR;
textbackground(black);
end;

procedure selectare_options(var x:integer);
begin
textbackground(black);
textcolor(white);
repeat
textcolor(white);
clrscr;
gotoxy(36,7);write('ฑฑฑ');
gotoxy(36,8);write('ฑ ฑ');
gotoxy(36,9);write('ฑฑฑPTIONS');
gotoxy(30,11);write('ษออออออออออออออออออออป');
gotoxy(30,16);write('ศออออออออออออออออออออผ');
gotoxy(30,12);write('บ',optionstype[1],' บ');
gotoxy(30,13);write('บ',optionstype[2],' บ');
gotoxy(30,14);write('บ',optionstype[3],' บ');
gotoxy(30,15);write('บ',optionstype[4],' บ');
textbackground(blue);
gotoxy(31,11+x);write(optionstype[x]);
textbackground(black);
dispare_cursor(80,25);
repeat
ch:=readkey;
until ch in [UP_ARROW,DOWN_ARROW,ENTER,ESCAPE];
if (ch=UP_ARROW) and (x>1) then dec(x)
   else if (ch=DOWN_ARROW) and (x<4) then inc(x);
until (ch=ENTER) or (ch=ESCAPE);
end;

procedure options;
var i:integer;
begin
i:=1;
repeat
selectare_options(i);
if (ch=ENTER) and (i=1) then settings('        Off        ','        Off        ',muzica)
   else if (ch=ENTER) and (i=2) then settings('     Available     ','    Unavailable    ',timesboolean)
   else if (ch=ENTER) and (i=3) then settings('        Hard       ','        Hard       ',muzica)
   else if (ch=ENTER) and (i=4) then ch:=ESCAPE;
until ch=ESCAPE;
ch:=SPACEBAR;
end;

procedure extras(var x:integer);
begin
textbackground(black);
textcolor(white);x:=1;
repeat
textcolor(white);
clrscr;
gotoxy(33,7);write('Select');
gotoxy(40,8);write('an');
gotoxy(43,9);write('extra !');
gotoxy(30,11);write('ษออออออออออออออออออออป');
gotoxy(30,16);write('ศออออออออออออออออออออผ');
gotoxy(30,12);write('บ',extrastype[1],' บ');
gotoxy(30,13);write('บ',extrastype[2],' บ');
gotoxy(30,14);write('บ',extrastype[3],' บ');
gotoxy(30,15);write('บ',extrastype[4],' บ');
textbackground(blue);
gotoxy(31,11+x);write(extrastype[x]);
textbackground(black);
dispare_cursor(80,25);
ch:=readkey;
if (ch=UP_ARROW) and (x>1) then dec(x)
   else if (ch=DOWN_ARROW) and (x<4) then inc(x);
until (ch=ENTER) or (ch=ESCAPE);
end;

procedure selectare_extras;
var nr:integer;
begin
nr:=1;
repeat
extras(nr);
if (ch=ENTER) and (nr=2) then afisare_high
   else if (ch=ENTER) and (nr=1) then help(ch)
   else if (ch=ENTER) and (nr=3) then credits
   else if (ch=ENTER) and (nr=4) then ch:=ESCAPE;
until ch=ESCAPE;
ch:=SPACEBAR;
end;

procedure salveaza(x:integer);
var y:text;
    a:lvlvec;
    i,j:integer;
begin
ASSIGN(y,'multi\SaveGame.txt');reset(y);
readln(y);
for j:=1 to maxlvl do readln(y,a[j].lvlul,a[j].open);
j:=0;
while (a[j+1].open=2) do inc(j);
close(y);
ASSIGN(y,'multi\SaveGame.txt');rewrite(y);
writeln(y,level,' ',points);
sterge_text;
gotoxy(height+latime div 2-10,hight+long+2);write('Your game was saved !');
dispare_cursor(80,25);
i:=1; while (i<=maxlvl) and (a[i].open=2) do begin writeln(y,i,' ',2); inc(i); end;
while (i<=maxlvl) and (i<=x) do begin writeln(y,i,' ',2);inc(i); end;
while (i<=maxlvl) do begin writeln(y,i,' ',1); inc(i); end;
close(y);
end;

procedure deschidere_fisier_text;
var nrds:integer;
begin
ASSIGN(f,stages[level]);reset(f);
readln(f,mapname);
readln(f,nrds);
for i:=1 to nrds do readln(f,instruction[i]);
readln(f,height,hight,long,latime);
readln(f,startx,starty,aix,aiy,nrf);
readln(f,lvltype,longboss,heightb,hightb,monstercolor);
for i:=1 to longboss do readln(f,bos[bx]);
readln(f,bar);
for i:=1 to long do readln(f,v[i]);
x:=startx;y:=starty;
close(f);
end;

procedure clr_game_scr;
begin
for i:=1 to long do
    for j:=1 to latime do begin
                 gotoxy(height+j,hight+i);write(' ');
                 end;
end;

procedure scriere_statistica;
begin
textbackground(black);
for i:=1 to lifes do begin
    textcolor(red);
    gotoxy(height+2*i,hight-1);write('');
    end;
textcolor(green);
gotoxy(height+latime-length(mapname),hight-1);write(mapname);
textcolor(white);
gotoxy(height,hight-2);write('ษ',bar,'ป');
gotoxy(height,hight-1);write('บ');gotoxy(height+latime+2,hight-1);write('บ');
end;

procedure scriere_text;
begin
textbackground(black);
textcolor(white);
gotoxy(height,hight+long+3);write('ศ',bar,'ผ');
gotoxy(height,hight+long+2);write('บ');gotoxy(height+latime+2,hight+long+2);write('บ');
textcolor(green);
gotoxy(height+latime div 2-15,hight+long+2);
write('Press ENTER to start the game !');
repeat
ch:=readkey;
until ch in [ENTER,ESCAPE,SPACEBAR];
sterge_text;
gotoxy(height+latime div 2-length(instruction[1]) div 2,hight+long+2);write(instruction[1]);
textbackground(blue);
textcolor(yellow);
end;

procedure scriere_mapa;
begin
deschidere_fisier_text;
textbackground(black);
clrscr;
scriere_statistica;
ciocanel:=0;
nrmf:=0;
gotoxy(height,hight);write('ฬ',bar,'น');
for i:=hight+1 to hight+long do begin
    gotoxy(height,i);write(chr(186));
    gotoxy(height+latime+2,i);write(chr(186));
    end;
gotoxy(height,hight+long+1);write('ฬ',bar,'น');
textbackground(blue);
textcolor(green);
clr_game_scr;
for i:=1 to long do
    for j:=1 to latime do begin
        gotoxy(height+j,hight+i);
        case v[i][j] of
        '': begin textcolor(red);writeln(v[i][j]);end;
        '@','','','','': begin textcolor(yellow);writeln(v[i][j]);end;
        'ฑ','๊': begin textcolor(green);writeln(v[i][j]);end;
        'ฐ' : begin textcolor(blue);writeln(v[i][j]);end;
        'ฒ' : begin textcolor(brown);writeln(v[i][j]);end;
        end;
    end;
textcolor(yellow);
gotoxy(height+y,hight+x);write(chr(1));gotoxy(height+y,hight+x);
gotoxy(height+aiy,hight+aix);write(chr(2));
scriere_text;
end;

procedure sterge_om;
begin
gotoxy(height+y,hight+x);write(' ');
end;

procedure afisare_fata_zambareata;
begin
textbackground(blue);
gotoxy(height+y,hight+x);write(chr(1));gotoxy(height+y,hight+x);
end;

procedure final_felicitari;
begin
textbackground(black);
textcolor(white);
sterge_text;
gotoxy(height+latime div 2-17,hight+long+2);
textcolor(green);
write('Congratulation, you finish the map !');
delay(2000);
end;

procedure item_viata;
begin
inc(lifes);
v[x][y]:=' ';
scriere_statistica;
sterge_text;
textcolor(green);
gotoxy(height+latime div 2-14,hight+long+2);write('You picked up one more life !');
textcolor(yellow);
textbackground(blue);
end;

procedure item_steag(var nr:integer);
begin
inc(nr);
v[x][y]:=' ';
scriere_statistica;
sterge_text;
textcolor(green);
gotoxy(height+latime div 2-10,hight+long+2);write('This was flag number ',nr,' !');
textcolor(yellow);
textbackground(blue);
end;

procedure item_final;
begin
if nrmf=nrf then begin v[x][y]:=' ';final:=true; inc(level); final_felicitari; end
            else begin textbackground(black);textcolor(green);sterge_text;
                       gotoxy(height+latime div 2 -14,hight+long+2);write('You don''t have enough flags !');
                       textbackground(blue);textcolor(yellow);
                 end;

end;

procedure incosuta(var point:pointype);
begin
point:=point+100;
end;

procedure item_stea(var point:pointype);
begin
textbackground(black);textcolor(green);sterge_text;
if point=0 then begin gotoxy(height+latime div 2-18,hight+long+2);
                      write('Collect STARS to take more points !');incosuta(point);end
            else begin incosuta(point);gotoxy(height+latime div 2-13,hight+long+2);
                       write('You have now, ',point,' points !');
                 end;
textbackground(blue);textcolor(yellow);
v[x][y]:=' ';
end;

procedure item_ciocanel(var cioc:patru);
begin
v[x][y]:=' ';
inc(cioc);
textbackground(black);textcolor(green);sterge_text;
gotoxy(height+2,hight+long+2);write('You picked up one more shield !');
textbackground(blue);textcolor(yellow);
okcio.ok:=false;
end;

procedure plasarecioc(var cioc:patru);
begin
if cioc>0 then begin
              dec(cioc);
              textbackground(black);textcolor(green);sterge_text;
              gotoxy(height+latime div 2-11,hight+long+2);write('You put a shield here !');
              textbackground(blue);textcolor(yellow);
              okcio.okx:=x;
              okcio.oky:=y;
              okcio.ok:=true;
                   end
              else begin
              textbackground(black);textcolor(green);sterge_text;
              gotoxy(height+latime div 2-14,hight+long+2);write('You don''t have any shields !');
              textbackground(blue);textcolor(yellow);
                   end;

end;

procedure afisare_ciocanel(var x:okcioc);
begin
if x.ok then begin v[x.okx,x.oky]:=''; gotoxy(x.oky+height,x.okx+hight); write('');end;
end;

procedure times;
begin
textbackground(black);
textcolor(white);
repeat
gotoxy(32,hight-1);
writeln('่ : ',time div 360000,':',time div 6000,':',(time div 100) mod 60,'.',time mod 100);
gotoxy(80,25);
delay(10);
inc(time);
until keypressed;
textcolor(yellow);
textbackground(blue);
end;

procedure end_stage;
begin
if final then begin
textbackground(black);
textcolor(white);
clrscr;
gotoxy(35,6);write('ฑ');
gotoxy(35,7);write('ฑ');
gotoxy(35,8);write('ฑฑEVEL STATS');
gotoxy(25,10);write('ษออออออออออออออออออออออออออออออป');
gotoxy(25,11);write('บ                              บ');
if timesboolean then begin
gotoxy(25,12);write('บ  You finish this level in    บ');
if time<6000 then begin
   gotoxy(25,13);write('บ          ');
   textcolor(yellow);write((time div 100) mod 60:2);
   textcolor(white);write(' seconds !        บ');end
   else begin
   gotoxy(25,13);write('บ     ');
   textcolor(yellow);write(time div 6000:2);
   textcolor(white);write(' min and ');
   textcolor(yellow);write((time div 100) mod 60:2);
   textcolor(white);write(' sec !      บ');
   end;
end
   else begin textcolor(white);gotoxy(25,12);write('บ                              บ');
              textcolor(yellow);gotoxy(26,12);write('  You need to have stopwatch  ');
              textcolor(white);gotoxy(25,13);write('บ                              บ');
              textcolor(yellow);gotoxy(26,13);write('       for this stats !       ');textcolor(white);
              end;
gotoxy(25,14);write('บ  You have now ');
textcolor(red);write(points:4);
textcolor(white);write(' points !  บ');
gotoxy(25,15);write('บ                              บ');
gotoxy(25,16);write('ศออออออออออออออออออออออออออออออผ');
dispare_cursor(80,25);
delay(2000);
repeat
ch:=readkey;
dispare_cursor(80,25);
until ch<>ESCAPE;
end;
end;

procedure selectare_level(vec:lvlvec; var x:integer);
var i:integer;
begin
x:=1;
repeat
textbackground(black);textcolor(white);
clrscr;
for i:=1 to maxlvl do begin
    gotoxy(30,25 div 2-maxlvl div 2+i);
    write('บ     Level ',vec[i].lvlul:2,'       บ');
                      end;
gotoxy(29,25 div 2-maxlvl div 2-3);write('Select an avaible level !');
gotoxy(30,25 div 2-maxlvl div 2);write('ษออออออออออออออออออออป');
gotoxy(30,25 div 2+maxlvl div 2+maxlvl mod 2+1);write('ศออออออออออออออออออออผ');
textbackground(blue);gotoxy(31,25 div 2-maxlvl div 2+x);
write('     Level ',x:2,'      ');textbackground(black);
dispare_cursor(80,25);
ch:=readkey;
if (ch=UP_ARROW) and (x>1) then dec(x)
   else if (ch=DOWN_ARROW) and (x<maxlvl) and (vec[x+1].open=2) then inc(x);
until (ch=ENTER) or (ch=ESCAPE);
ch:=SPACEBAR
end;

procedure ia_level;
var fisier:text;
    i:integer;
    a:lvlvec;
begin
clrscr;
textbackground(black);textcolor(white);
ASSIGN(fisier,'multi\savegame.txt');reset(fisier);
readln(fisier);
for i:=1 to maxlvl do readln(fisier,a[i].lvlul,a[i].open);
close(fisier);
selectare_level(a,i);
level:=i
end;

procedure good_job;
begin
textbackground(black);
textcolor(blue);
clrscr;
gotoxy(25,10);write('ฑฑฑ ฑฑฑ ฑฑฑ ฑฑ       ฑ ฑฑฑ  ฑฑฑ   ฑ');
gotoxy(25,11);write('ฑ   ฑ ฑ ฑ ฑ ฑ ฑ      ฑ ฑ ฑ  ฑ_ฑ   ฑ');
gotoxy(25,12);write('ฑ ฑ ฑ ฑ ฑ ฑ ฑ ฑ    ฑ ฑ ฑ ฑ  ฑ ฑ');
gotoxy(25,13);write('ฑฑฑ ฑฑฑ ฑฑฑ ฑฑ     ฑฑฑ ฑฑฑ  ฑฑฑ   ฑ');
dispare_cursor(80,25);
textcolor(white);
delay(2000);gotoxy(25,16);write('You finish the Game !');gotoxy(80,25);
delay(2000);gotoxy(34,18);write('Really good job !');gotoxy(80,25);
delay(2000);gotoxy(44,3);write('Game by Lambru Andrei Cristian !');gotoxy(80,25);
delay(2000);
ch:=readkey;
end;

procedure game_over;
begin
textbackground(black);
textcolor(red);
clrscr;
gotoxy(22,10);write('ฑฑฑ ฑฑฑ ฑ ฑ ฑฑฑ      ฑฑฑ ฑ ฑ ฑฑฑ ฑฑฑ');
gotoxy(22,11);write('ฑ   ฑ ฑ ฑฑฑ ฑ__      ฑ ฑ ฑ ฑ ฑ__ ฑ ฑ');
gotoxy(22,12);write('ฑ ฑ ฑฑฑ ฑ ฑ ฑ        ฑ ฑ ฑ ฑ ฑ   ฑฑฑ');
gotoxy(22,13);write('ฑฑฑ ฑ ฑ ฑ ฑ ฑฑฑ      ฑฑฑ  ฑ  ฑฑฑ ฑ \');
gotoxy(22,14);write('| | |     | |        |    |  ||  | |');
gotoxy(22,15);write('                     |    |  |      ');
dispare_cursor(80,25);
repeat
ch:=readkey;
until ch in [SPACEBAR,ENTER];
end;

procedure game_end;
begin
if final then begin good_job; shigh:=true; end
   else if lifes=0 then begin game_over; shigh:=true; end
   else if ch=ESCAPE then shigh:=true;
end;

procedure miscare_fata_zambareata;
begin
repeat
if timesboolean then times;
ch:=readkey;
afisare_ciocanel(okcio);
until ch in [LEFT_ARROW,RIGHT_ARROW,UP_ARROW,DOWN_ARROW,ENTER,SPACEBAR,ESCAPE];
if (ch=LEFT_ARROW) and (v[x][y-1]<>'ฑ') then begin
                   sterge_om;y:=y-1;afisare_fata_zambareata;end
   else if (ch=RIGHT_ARROW) and (v[x][y+1]<>'ฑ') then begin
                   sterge_om;y:=y+1;afisare_fata_zambareata;end
   else if (ch=UP_ARROW) and (v[x-1][y]<>'ฑ') then begin
                   sterge_om;x:=x-1;afisare_fata_zambareata;end
   else if (ch=DOWN_ARROW) and (v[x+1][y]<>'ฑ') then begin
                   sterge_om;x:=x+1;afisare_fata_zambareata;end
   else if (ch=SPACEBAR) then plasarecioc(ciocanel);
case v[x][y] of
'': item_viata;
'': item_steag(nrmf);
'': item_final;
'': item_stea(points);
'': item_ciocanel(ciocanel);
end;
end;

procedure te_prinde_centaurul;
begin
textbackground(black);textcolor(green);sterge_text;
gotoxy(height+latime div 2-17,hight+long+2);write('The centaur catch you ! Try again !');
dec(lifes);delay(2000);
end;

procedure afisare_hot;
begin
gotoxy(height+aiy,hight+aix);write(chr(2));
end;

procedure sterge_hot;
begin
gotoxy(height+aiy,hight+aix);write(' ');
end;

procedure continues;
begin
if not(continue) then begin level:=1;
                            points:=0;
                      end;
end;

function te_vede_centaurul:boolean;
var nrd:integer;
begin
te_vede_centaurul:=false;
if (aix>x) and (aiy=y) then begin
           nrd:=aix;
           repeat
           nrd:=nrd-1;
           until (v[nrd][aiy]='ฑ') or (nrd=x);
                 end
   else if (aix<x) and (aiy=y) then begin
           nrd:=aix;
           repeat
           inc(nrd);
           until (v[nrd][aiy]='ฑ') or (nrd=x);
                 end
   else if (aiy<y) and (aix=x) then begin
           nrd:=aiy;
           repeat
           inc(nrd);
           until (v[aix][nrd]='ฑ') or (nrd=y);
                 end
   else if (aiy>y) and (aix=x) then begin
           nrd:=aiy;
           repeat
           nrd:=nrd-1;
           until (v[aix][nrd]='ฑ') or (nrd=y);
                 end;
if (nrd=x) or (nrd=y) then te_vede_centaurul:=true;
end;

procedure inteligenta_artificiala;
begin
if (aix<x) and (v[aix+1][aiy]=' ') then begin
           sterge_hot;inc(aix);afisare_hot;end
   else if (aix>x) and (v[aix-1][aiy]=' ') then begin
           sterge_hot;aix:=aix-1;afisare_hot;end
   else if (aiy<y) and (v[aix][aiy+1]=' ') then begin
           sterge_hot;inc(aiy);afisare_hot;end
   else if (aiy>y) and (v[aix][aiy-1]=' ') then begin
           sterge_hot;aiy:=aiy-1;afisare_hot;end;
if te_vede_centaurul then te_prinde_centaurul;
gotoxy(80,25);
end;

procedure stagnare_joc(var x:char);
begin
x:='x';
end;

procedure initializeaza_mouse;
begin
mouseinit;
mouseshow;
end;

procedure joc_in_sine;
begin
final:=false;
time:=0;
repeat
scriere_mapa;
repeat
miscare_fata_zambareata;
inteligenta_artificiala;
until ((final) and (nrmf=nrf)) or (te_vede_centaurul) or (ch=ESCAPE);
until (lifes=0) or (ch=ESCAPE) or (final);
end;

begin
citire_highs;
citire_informatii_joc(stages,maxlvl);
shigh:=false;
muzica:=false;
initializeaza_mouse;
timesboolean:=true;
exiti:=false;
repeat
meniu(option);
if (ch=ENTER) and (option=1) then begin
                                     settings('     Continue      ','     New Game      ',continue);
                                     continues;
                                     if level=1 then begin textul('multi\story\story.txt',17,4);ch:=readkey; end;

                     repeat
                     repeat
                     joc_in_sine;
                     until (ch=ESCAPE) or (lifes=0) or (final);
                     end_stage;
                     until (ch=ESCAPE) or (lifes=0) or (level>maxlvl);
                     salveaza(level);
                     stagnare_joc(ch);
                     game_end;
                     end
    else if (ch=ENTER) and (option=2) then ia_level
    else if (ch=ENTER) and (option=3) then options
    else if (ch=ENTER) and (option=4) then selectare_extras
    else if ((ch=ENTER) and (option=5)) or (ch=ESCAPE) then settings('       Exit        ','       Stay        ',exiti);
until exiti;
end.
