codeunit 60190 "ARM_CustomValidator"
{
    procedure TextToHtml(txtValue: Text): Text var
        typehelp: Codeunit "Type Helper";
        crlf: Text[2];
        txt: Text;
    begin
        crlf:=typehelp.CRLFSeparator();
        txt:=txtValue;
        txt:=txt.Replace(crlf[1], '<br/>');
        txt:=txt.Replace(crlf[2], '<br/>');
        exit(txt);
    end;
    procedure HtmlToText(txtValue: Text): Text var
        typehelp: Codeunit "Type Helper";
        crlf: Text[2];
        txt: Text;
    begin
        crlf:=typehelp.CRLFSeparator();
        txt:=txtValue;
        txt:=txt.Replace('<br/>', crlf);
        exit(txt);
    end;
    procedure StrCountOccurencies(tValue: Text; tFind: Text): Integer var
        iReturnValue: Integer;
        iPosAux: Integer;
        tAux: Text;
    begin
        iReturnValue:=0;
        if StrLen(tValue) > 0 then begin
            iPosAux:=StrPos(tValue, tFind);
            tAux:=tValue;
            while(iPosAux > 0)do begin
                iReturnValue:=iReturnValue + 1;
                iPosAux:=iPosAux + 1;
                tAux:=CopyStr(tAux, iPosAux);
                iPosAux:=StrPos(tAux, tFind);
            end;
        end;
        exit(iReturnValue);
    end;
    procedure ValidateEmail(tEmailSource: Text; var emailList: List of[Text]): Boolean var
        iAux: Integer;
        iLastDot: Integer;
        tAux: Text;
        tEmailsSemicolon: List of[Text];
        tAllowedCharacters: Text;
        tEmailSemicolon: Text;
        tEmailsComma: List of[Text];
        tEmail: Text;
        emailListAux: List of[Text];
    begin
        if(tEmailSource = '')then exit(true);
        Clear(emailList);
        Clear(emailListAux);
        Clear(tEmailsSemicolon);
        Clear(tEmailsComma);
        tEmailsSemicolon:=tEmailSource.Split(';');
        foreach tEmailSemicolon in tEmailsSemicolon do begin
            tEmailSemicolon:=tEmailSemicolon.Trim();
            tEmailsComma:=tEmailSemicolon.Split(',');
            foreach tEmail in tEmailsComma do begin
                emailListAux.Add(tEmail);
                tAux:=tEmail.Trim();
                //check special characters
                tAllowedCharacters:='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.@-abcdefghijklmnopqrstuvwxyz_+';
                tAux:=DelChr(tAux, '=', tAllowedCharacters);
                if StrLen(tAux) > 0 then exit(false);
                //check more than one @
                iAux:=StrCountOccurencies(tEmail, '@');
                if iAux > 1 then exit(false);
                if iAux < 1 then exit(false);
                //check last after .
                iLastDot:=StrLastPos(tEmail, '.');
                if iLastDot = 0 then exit(false);
                iAux:=StrLen(tEmail);
                if StrLen(tEmail) - iLastDot > 5 then exit(false);
                if(StrLen(tEmailSource) > 80)then exit(false);
            end;
        end;
        emailList.AddRange(emailListAux);
        exit(true);
    end;
    procedure ValidateTime(timeStr: Text[50]; var final: Time): Boolean var
        parts: List of[Text];
        timeInt: Integer;
        isAM: Boolean;
        isPM: Boolean;
        hour: Integer;
        minute: Integer;
        hours12: Integer;
        auxStr: Text[50];
        hours9am: Time;
        hours12pm: Time;
        hours12am: Time;
    begin
        final:=0T;
        hours9am:=060000T;
        hours12am:=000000T;
        hours12pm:=120000T;
        hours12:=216000000; //12 hours in milliseconds
        isAM:=false;
        isPM:=false;
        if(timeStr = '')then begin
            exit(true);
        end;
        timeStr:=timeStr.Trim();
        timeStr:=LowerCase(timeStr);
        if(timeStr.Contains('am'))then begin
            isAM:=true;
            timeStr:=timeStr.Replace('am', '');
        end;
        if(timeStr.Contains('pm'))then begin
            isPM:=true;
            timeStr:=timeStr.Replace('pm', '');
        end;
        if(timeStr.Contains('a'))then begin
            isAM:=true;
            timeStr:=timeStr.Replace('a', '');
        end;
        if(timeStr.Contains('p'))then begin
            isPM:=true;
            timeStr:=timeStr.Replace('p', '');
        end;
        timeStr:=timeStr.Trim();
        if(final = 0T)then begin
            if(timeStr.Contains(':'))then begin
                parts:=timeStr.Split(':');
                if(parts.Count() > 0)then begin
                    if(Evaluate(hour, parts.Get(1)) = false)then begin
                        exit(false);
                    end
                    else
                    begin
                        if(hour <= 0) or (hour >= 24)then begin
                            exit(false);
                        end;
                    end;
                end;
                if(parts.Count() > 1)then begin
                    if(Evaluate(minute, parts.Get(2)) = false)then begin
                        exit(false);
                    end
                    else
                    begin
                        if(hour < 0) or (hour > 59)then begin
                            exit(false);
                        end;
                    end;
                end;
                auxStr:=StrSubstNo('%1:%2', IntToTextLeadingZeros(hour, 2), IntToTextLeadingZeros(minute, 2));
                if(isAM = true) AND (isPM = false)then begin
                    auxStr:=auxStr + 'am';
                end;
                if(isAM = false) AND (isPM = true)then begin
                    auxStr:=auxStr + 'pm';
                end;
                if(Evaluate(final, auxStr) = false)then begin
                    exit(false);
                end;
            end;
        end;
        if(final = 0T)then begin
            if(Evaluate(timeInt, timeStr) = false)then begin
                exit(false);
            end;
            if(timeInt < 0) OR (timeInt > 2400)then begin
                exit(false);
            end;
            if(timeInt < 10)then auxStr:='0' + Format(timeInt) + '00'
            else
            begin
                if(timeInt < 24)then auxStr:=Format(timeInt) + '00'
                else
                    auxStr:=IntToTextLeadingZeros(timeInt, 4);
            end;
            timeStr:=StrSubstNo('%1:%2', CopyStr(auxStr, 1, 2), CopyStr(auxStr, 3, 2));
            if(Evaluate(final, timeStr) = false)then begin
                final:=0T;
            end;
        end;
        if(final <> 0T)then begin
            if(isAM = false) AND (isPM = false)then begin
                if(final > hours12am) AND (final < hours9am)then begin
                    final:=final + hours12;
                end;
            end
            else
            begin
                if isAM then begin
                    if final >= hours12pm then begin
                        final:=final + hours12;
                    end;
                end;
                if isPM then begin
                    if final < hours12pm then begin
                        final:=final + hours12;
                    end;
                end;
            end;
        end;
        exit(true);
    end;
    procedure StrLastPos(tValue: Text; tFind: Text): Integer var
        iReturnValue: Integer;
        iPos: Integer;
        tAux: Text;
    begin
        iReturnValue:=0;
        if StrLen(tValue) > 0 then begin
            iPos:=StrPos(tValue, tFind);
            tAux:=tValue;
            while(iPos > 0)do begin
                iReturnValue:=iReturnValue + iPos;
                iPos:=iPos + 1;
                tAux:=CopyStr(tAux, iPos);
                iPos:=StrPos(tAux, tFind);
            end;
        end;
        exit(iReturnValue);
    end;
    procedure getCRLF(): Text var
        tRet: Text;
    begin
        tRet:='xx';
        tRet[1]:=13;
        tRet[2]:=10;
        exit(tRet);
    end;
    procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text)NewString: Text var
        FindPos: Integer;
    begin
        FindPos:=StrPos(String, FindWhat);
        while FindPos > 0 do begin
            NewString+=DelStr(String, FindPos) + ReplaceWith;
            String:=CopyStr(String, FindPos + StrLen(FindWhat));
            FindPos:=StrPos(String, FindWhat);
        end;
        NewString+=String;
    end;
    procedure IntToTextLeadingZeros(number: Integer; lenght: Integer)NewString: Text begin
        NewString:=PADSTR('', lenght - STRLEN(FORMAT(number)), '0') + FORMAT(number);
    end;
    procedure IntToTextEndingZeros(number: Integer; lenght: Integer)NewString: Text begin
        NewString:=FORMAT(number) + PADSTR('', lenght - STRLEN(FORMAT(number)), '0');
    end;
    procedure AddHoursToDateTime(t1: DateTime; t2: Integer): DateTime var
        tRet: DateTime;
    begin
        tRet:=t1 + (t2 * 3600000);
        exit(tRet);
    end;
    procedure AddHoursToDate(t1: Date; t2: Integer): Date var
        tRet: Date;
        aux: Text[30];
    begin
        t2:=t2 / 24;
        aux:=StrSubstNo('<+%1D>', t2);
        tRet:=CalcDate(aux, t1);
        exit(tRet);
    end;
    procedure convertDurationMinutesToText(minutes: Integer): Text var
        intHours: Integer;
        intMinutes: Integer;
        retValue: Text;
        bigInt: BigInteger;
    begin
        retValue:='';
        if(minutes <= 1440) and (minutes >= 0)then begin
            bigInt:=minutes * 60000;
            intHours:=bigInt DIV (60 * 60 * 1000);
            intMinutes:=(bigInt MOD (60 * 60 * 1000)) DIV (60 * 1000);
            retValue:=StrSubstNo('%1:%2:00', FORMAT(intHours, 0, '<Integer,2><Filler,0>'), FORMAT(intMinutes, 0, '<Integer,2><Filler,0>'));
        end;
        exit(retValue);
    end;
    procedure convertDurationTypeToText(_duration: Duration): Text var
        intHours: Integer;
        intMinutes: Integer;
        retValue: Text;
        bigInt: BigInteger;
    begin
        retValue:='';
        if(_duration <= (1440 * 60000))then begin
            bigInt:=_duration;
            intHours:=bigInt DIV (60 * 60 * 1000);
            intMinutes:=(bigInt MOD (60 * 60 * 1000)) DIV (60 * 1000);
            retValue:=StrSubstNo('%1:%2:00', FORMAT(intHours, 0, '<Integer,2><Filler,0>'), FORMAT(intMinutes, 0, '<Integer,2><Filler,0>'));
        end;
        exit(retValue);
    end;
    procedure getTimeFormatted(_time: Time): Text var
        retValue: Text[20];
    begin
        retValue:=StrSubstNo('%1', Format(_time, 0, '<Hours12>:<Minutes,2> <AM/PM>'));
        if(_time = 0T) OR (retValue = '12:00 AM')then retValue:='';
        exit(retValue);
    end;
    procedure getDayMonthYear(_date: Date; var day: Integer; var month: Integer; var year: Integer)
    begin
        day:=0;
        month:=0;
        year:=0;
        if(_date <> 0D)then begin
            day:=Date2DMY(_date, 1);
            month:=Date2DMY(_date, 2);
            year:=Date2DMY(_date, 3);
        end;
    end;
    procedure TimeToString(_time: Time): Text var
        retval: Text;
    begin
        retval:='';
        if(_time <> 0T)then retval:=StrSubstNo('%1', Format(_time, 0, '<Hours12>:<Minutes,2> <AM/PM>'));
        exit(retval);
    end;
    procedure ListOfTextToSeparatedText(lst: List of[Text]; sep: Text): Text[2000]var
        ret: Text[2000];
        auxStr: Text;
        cu: Codeunit ARM_CustomValidator;
    begin
        ret:='';
        FOREACH auxStr IN lst DO BEGIN
            if ret <> '' then ret+=sep;
            ret+=auxStr;
        END;
        exit(ret);
    end;
    procedure ReduceSpaces(InputString: Text)OutputString: Text var
        n: Integer;
        i: Integer;
    begin
        n:=STRLEN(InputString);
        FOR i:=1 TO n DO IF(InputString[i] = ' ') AND (i < n)THEN BEGIN
                IF NOT(InputString[i + 1]IN[32 .. 47, 58 .. 63])THEN //if the next char is special as 'empty space,.,!' etc we do not copy the current space
 OutputString+=FORMAT(InputString[i])END
            ELSE
                OutputString+=FORMAT(InputString[i]);
        OutputString:=DELCHR(OutputString, '<>', ' ');
    end;
}
