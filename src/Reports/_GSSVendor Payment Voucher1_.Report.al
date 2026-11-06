report 60119 "GSSVendor Payment Voucher1"
{
    // version GSS
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/Vendor Payment Voucher.rdl';
    Caption = 'Vendor Payment Voucher';

    dataset
    {
        dataitem("G/L Register"; "G/L Register")
        {
            DataItemTableView = SORTING("No.")ORDER(Ascending);
            RequestFilterFields = "No.";

            column(PreparedBy; "G/L Register"."User ID")
            {
            }
            dataitem("G/L Entry1"; "G/L Entry")
            {
                DataItemTableView = SORTING("Document No.", "Posting Date", Amount)ORDER(Descending)WHERE("Journal Batch Name"=FILTER(<>''));
                MaxIteration = 1;
                RequestFilterFields = "Entry No.", "Document No.", "Posting Date";

                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Cash_Payment_Voucher_;'Payment Voucher')
                {
                }
                column(G_L_Entry1__Document_No__; "Document No.")
                {
                }
                column(FORMAT__Posting_Date__; FORMAT("Posting Date"))
                {
                }
                column(RecVend_Name; RecVend.Name)
                {
                }
                column(RecVend_Address; GLEntry."Document Date")
                {
                }
                column(RecVend_Contact; GLEntry."External Document No.")
                {
                }
                column(CompanyInformation_Address; CompanyInformation.Address)
                {
                }
                column(CompanyInformation_Name; CompanyInformation.Name)
                {
                }
                column(CompanyInformation_City______CompanyInformation__Country_Region_Code_; CompanyInformation.City + '  ' + CompanyInformation."Country/Region Code")
                {
                }
                column(PO_Box_________CompanyInformation__Post_Code_;'PO Box :' + '  ' + CompanyInformation."Post Code")
                {
                }
                column(Phone_________CompanyInformation__Phone_No__;'Phone :' + '  ' + CompanyInformation."Phone No.")
                {
                }
                column(Fax_________CompanyInformation__Fax_No__;'Fax :' + '  ' + CompanyInformation."Fax No.")
                {
                }
                column(CompanyInformation_Picture; CompanyInformation.Picture)
                {
                }
                column(Voucher_No_____Caption; Voucher_No_____CaptionLbl)
                {
                }
                column(Voucher_Date__Caption; Voucher_Date__CaptionLbl)
                {
                }
                column(Paid_to_M_S_Mr__Mrs_Caption; Paid_to_M_S_Mr__Mrs_CaptionLbl)
                {
                }
                column(AddressCaption; AddressCaptionLbl)
                {
                }
                column(Contact_DetailsCaption; Instrument_no_CaptionLbl)
                {
                }
                column(Inst_DateCaption; Instrument_Date_CaptionLbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(EmptyStringCaption_Control1000000072; EmptyStringCaption_Control1000000072Lbl)
                {
                }
                column(EmptyStringCaption_Control1000000073; EmptyStringCaption_Control1000000073Lbl)
                {
                }
                column(Credit_AmountCaption; Credit_AmountCaptionLbl)
                {
                }
                column(Debit_AmountCaption; Debit_AmountCaptionLbl)
                {
                }
                column(Account_No_Caption; Account_No_CaptionLbl)
                {
                }
                column(Account_NameCaption; Account_NameCaptionLbl)
                {
                }
                column(G_L_Entry__Global_Dimension_1_Code_Caption; "G/L Entry".FIELDCAPTION("Global Dimension 1 Code"))
                {
                }
                column(Prepared_by_Caption; Prepared_by_CaptionLbl)
                {
                }
                column(Checked_by_Caption; Checked_by_CaptionLbl)
                {
                }
                column(Approved_by_Caption; Approved_by_CaptionLbl)
                {
                }
                column(Received_by__Caption; Received_by__CaptionLbl)
                {
                }
                column(Verified_by__Caption; Verified_by__CaptionLbl)
                {
                }
                column(G_L_Entry1_Entry_No_; "Entry No.")
                {
                }
                column(BankTotalCurr; BankTotal)
                {
                }
                column(BanktotalCurrLbl;'Bank Total' + '  ' + '(' + GLSetup."LCY Code" + ')' + ':')
                {
                }
                column(ChequeNo; RecVLE."GSSInstrument No.")
                {
                }
                column(ChequeDate; FORMAT(RecVLE."GSSInstrument Date"))
                {
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "Document No."=FIELD("Document No.");
                    DataItemTableView = SORTING("Document No.", "Posting Date", Amount)ORDER(Descending)WHERE("Journal Batch Name"=FILTER(<>''));

                    column(G_L_Entry__Credit_Amount_; "Credit Amount")
                    {
                    }
                    column(G_L_Entry__Debit_Amount_; "Debit Amount")
                    {
                    }
                    column(GLAccName; GLAccName)
                    {
                    }
                    column(G_L_Entry__G_L_Account_No__; "G/L Account No.")
                    {
                    }
                    column(G_L_Entry__Global_Dimension_1_Code_; "Global Dimension 1 Code")
                    {
                    }
                    column(G_L_Entry__G_L_Entry___Credit_Amount_; "G/L Entry"."Credit Amount")
                    {
                    }
                    column(G_L_Entry__G_L_Entry___Debit_Amount_; "G/L Entry"."Debit Amount")
                    {
                    }
                    column(Total___________GLSetup__LCY_Code_____;'Total' + '  ' + '(' + GLSetup."LCY Code" + ')')
                    {
                    }
                    column(GLSetup__LCY_Code_______NumberText_1_______NumberText_2_; GLSetup."LCY Code" + '  ' + NumberText[1] + ' ' + NumberText[2] + ' ' + ' ONLY')
                    {
                    }
                    column(GLEntry_Narration; "G/L Entry"."ATOS Narration")
                    {
                    }
                    column(Sum_of__Caption; Sum_of__CaptionLbl)
                    {
                    }
                    column(Narration__Caption; Narration__CaptionLbl)
                    {
                    }
                    column(Continued______Caption; Continued______CaptionLbl)
                    {
                    }
                    column(G_L_Entry_Entry_No_; "Entry No.")
                    {
                    }
                    column(G_L_Entry_Document_No_; "Document No.")
                    {
                    }
                    column(G_L_Entry_Document_Date_; FORMAT("Document Date"))
                    {
                    }
                    trigger OnAfterGetRecord();
                    begin
                        GLAccName:=FindGLAccName("Source Type", "Entry No.", "Source No.", "G/L Account No.");
                        if Amount < 0 then begin
                            CrText:='To';
                            DrText:='';
                        end
                        else
                        begin
                            CrText:='';
                            DrText:='Dr';
                        end;
                        SourceDesc:='';
                        if "Source Code" <> '' then begin
                            SourceCode.GET("Source Code");
                            SourceDesc:=SourceCode.Description;
                        end;
                        PageLoop:=PageLoop - 1;
                        LinesPrinted:=LinesPrinted + 1;
                        ChequeNo:='';
                        ChequeDate:=0D;
                        if("Source No." <> '') and ("Source Type" = "Source Type"::"Bank Account")then begin
                            if BankAccLedgEntry.GET("Entry No.")then begin
                            // ChequeNo := BankAccLedgEntry."Check No.";
                            //   ChequeDate := BankAccLedgEntry."Check Date";
                            end;
                        end;
                        //decDebitTotal += ABS("Debit Amount");
                        decDebitTotal:=0;
                        GLentry1.RESET;
                        GLentry1.SETRANGE("Document No.", "Document No.");
                        if GLentry1.FINDSET then repeat decDebitTotal+=ABS(GLentry1."Debit Amount");
                            until GLentry1.NEXT = 0;
                        CLEAR(BankTotal);
                        GLentry1.RESET;
                        GLentry1.SETRANGE("Document No.", "Document No.");
                        GLentry1.SETRANGE("Source Type", GLentry1."Source Type"::"Bank Account");
                        if GLentry1.FINDSET then repeat BankTotal+=ABS(GLentry1.Amount);
                            until GLentry1.NEXT = 0;
                        InitTextVariable;
                        //FormatNoText(NumberText,decDebitTotal,'');
                        FormatNoText(NumberText, BankTotal, '');
                    end;
                    trigger OnPreDataItem();
                    begin
                        NUMLines:=13;
                        PageLoop:=NUMLines;
                        LinesPrinted:=0;
                    end;
                }
                dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
                {
                    DataItemTableView = WHERE("Entry Type"=FILTER(Application));
                    UseTemporary = true;

                    column(Detailed_Vendor_Ledg__Entry__Posting_Date_; FORMAT(RecVLE1."Posting Date"))
                    {
                    }
                    column(Detailed_Vendor_Ledg__Entry__Amount__LCY__; ABS("Amount (LCY)"))
                    {
                    }
                    column(RecVLE1__External_Document_No__; RecVLE1."External Document No.")
                    {
                    }
                    column(ABS_RecVLE1__Original_Amt___LCY___; ABS("Amount (LCY)"))
                    {
                    }
                    column(ABS_RecVLE1__Remaining_Amt___LCY___; "Amount (LCY)")
                    {
                    }
                    column(Detailed_Vendor_Ledg__Entry__Amount__LCY___Control1000000051; "Amount (LCY)")
                    {
                    }
                    column(Total___________GLSetup__LCY_Code______Control1000000057;'Total' + '  ' + '(' + GLSetup."LCY Code" + ')')
                    {
                    }
                    column(Applied_EntriesCaption; Applied_EntriesCaptionLbl)
                    {
                    }
                    column(Invoice_DateCaption; Invoice_DateCaptionLbl)
                    {
                    }
                    column(Invoice_No_Caption; Invoice_No_CaptionLbl)
                    {
                    }
                    column(Applied_AmountCaption; Applied_AmountCaptionLbl)
                    {
                    }
                    column(Remaining_AmountCaption; Remaining_AmountCaptionLbl)
                    {
                    }
                    column(Original_AmountCaption; Original_AmountCaptionLbl)
                    {
                    }
                    column(Detailed_Vendor_Ledg__Entry_Entry_No_; "Entry No.")
                    {
                    }
                    column(Detailed_Vendor_Ledg__Entry_Document_No_; RecVLE1."Document No.")
                    {
                    }
                    column(decAmtTotal; decAmtTotal)
                    {
                    }
                    column(InvoiceStatus; InvoiceStatus)
                    {
                    }
                    column(TotalSOValue; TotalSOValue)
                    {
                    }
                    column(TotalPOValue; TotalPOValue)
                    {
                    }
                    column(TotalSOInvoicedValue; TotalSOInvoicedValue)
                    {
                    }
                    column(TotalPaidForthatPO; TotalPaidForthatPO)
                    {
                    }
                    column(CustName; CustName)
                    {
                    }
                    column(SONo; SONo)
                    {
                    }
                    column(TotalPaidbyCust; TotalPaidbyCust)
                    {
                    }
                    trigger OnAfterGetRecord();
                    begin
                        RecVLE1.GET("Detailed Vendor Ledg. Entry"."Vendor Ledger Entry No.");
                        /*
                        RecVLE1.CALCFIELDS(RecVLE1."Original Amt. (LCY)",RecVLE1."Remaining Amt. (LCY)");
                        
                        decAmtTotal += RecVLE1."Original Amt. (LCY)";
                        */
                        //GSS
                        CLEAR(TotalPOValue);
                        CLEAR(TotalSOValue);
                        CLEAR(TotalPaidForthatPO);
                        CLEAR(TotalSOInvoicedValue);
                        CLEAR(TotalPaidbyCust);
                        CLEAR(SONo);
                        CLEAR(CustName);
                        PurchInvHead.SETRANGE("No.", RecVLE1."Document No.");
                        if PurchInvHead.FINDFIRST then PO.SETRANGE(PO."No.", PurchInvHead."Order No.");
                        if PO.FINDFIRST then begin
                            VLEDesc:='Order ' + PO."No.";
                            VLE.SETRANGE(VLE.Description, VLEDesc);
                            if VLE.FINDFIRST then repeat VLE.CALCFIELDS("Remaining Amount", Amount);
                                    TotalPaidForthatPO+=-VLE.Amount + VLE."Remaining Amount";
                                until VLE.NEXT = 0;
                            PO.CALCFIELDS("Amount Including VAT");
                            TotalPOValue:=PO."Amount Including VAT";
                            /* ITOS
                            PO.CALCFIELDS("Sales Order");
                            if PO."Sales Order" <> '' then
                              SO.SETRANGE(SO."No.",PO."Sales Order")
                            else
                              SO.SETRANGE(SO."No.",PO."SO No.");
                              */
                            if SO.FINDFIRST then begin
                                SONo:=SO."No.";
                                CustName:=SO."Sell-to Customer Name";
                                SO.CALCFIELDS("Amount Including VAT");
                                TotalSOValue:=SO."Amount Including VAT";
                                Descr:='Order ' + SO."No.";
                                SalesInvHeader.SETRANGE("Order No.", SO."No.");
                                if SalesInvHeader.FINDFIRST then repeat SalesInvHeader.CALCFIELDS("Amount Including VAT");
                                        TotalSOInvoicedValue+=SalesInvHeader."Amount Including VAT";
                                    until SalesInvHeader.NEXT = 0;
                                CLE.SETRANGE(CLE.Description, Descr);
                                if CLE.FINDFIRST then repeat CLE.CALCFIELDS("Remaining Amount", Amount);
                                        //IF CLE.Amount = CLE."Remaining Amount"  THEN
                                        TotalPaidbyCust+=CLE.Amount - CLE."Remaining Amount" //ELSE
                                    //TotalPaidbyCust += CLE."Remaining Amount";
                                    until CLE.NEXT = 0;
                            //END;
                            end;
                        end;
                    //GSS
                    end;
                }
                trigger OnAfterGetRecord();
                begin
                    RecVLE.RESET;
                    RecVLE.SETRANGE("Document No.", "Document No.");
                    if RecVLE.FINDFIRST then if RecVend.GET(RecVLE."Vendor No.")then;
                    //
                    FindApplnEntriesDtldtLedgEntry(RecVLE, "Detailed Vendor Ledg. Entry");
                    //
                    BankAccLedgEntry.RESET;
                    BankAccLedgEntry.SETRANGE("Document No.", "Document No.");
                    if BankAccLedgEntry.FINDFIRST then;
                end;
                trigger OnPreDataItem();
                begin
                    SETRANGE("Document No.", GL."Document No.");
                end;
            }
            trigger OnAfterGetRecord();
            begin
                GL.SETRANGE("Entry No.", "From Entry No."); // O2Gen
                if GL.FINDFIRST then;
            end;
        }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
        GLSetup.GET;
    end;
    var CompanyInformation: Record "Company Information";
    SourceCode: Record "Source Code";
    GLEntry: Record "G/L Entry";
    BankAccLedgEntry: Record "Bank Account Ledger Entry";
    GLAccName: Text[50];
    SourceDesc: Text[50];
    CrText: Text[2];
    DrText: Text[2];
    NumberText: array[2]of Text[80];
    PageLoop: Integer;
    LinesPrinted: Integer;
    NUMLines: Integer;
    ChequeNo: Code[20];
    ChequeDate: Date;
    OnesText: array[20]of Text[30];
    TensText: array[10]of Text[30];
    ExponentText: array[5]of Text[30];
    PrintLineNarration: Boolean;
    GLSetup: Record "General Ledger Setup";
    BankName: Code[10];
    RecVLE: Record "Vendor Ledger Entry";
    RecVend: Record Vendor;
    RecVLE1: Record "Vendor Ledger Entry";
    Voucher_No_____CaptionLbl: Label 'Voucher No.   :';
    Voucher_Date__CaptionLbl: Label 'Posting Date :';
    Paid_to_M_S_Mr__Mrs_CaptionLbl: Label 'Paid to M/S/Mr./Mrs.';
    AddressCaptionLbl: Label 'Document Date :';
    Instrument_no_CaptionLbl: Label 'Instrument No. :';
    Instrument_Date_CaptionLbl: Label 'Instrument Date :';
    EmptyStringCaptionLbl: Label ':';
    EmptyStringCaption_Control1000000072Lbl: Label ':';
    EmptyStringCaption_Control1000000073Lbl: Label ':';
    Credit_AmountCaptionLbl: Label 'Credit Amount';
    Debit_AmountCaptionLbl: Label 'Debit Amount';
    Account_No_CaptionLbl: Label 'Account No.';
    Account_NameCaptionLbl: Label 'Account Name';
    Prepared_by_CaptionLbl: Label 'Prepared by:';
    Checked_by_CaptionLbl: Label 'Checked by:';
    Approved_by_CaptionLbl: Label 'Approved by:';
    Received_by__CaptionLbl: Label 'Received by :';
    Verified_by__CaptionLbl: Label 'Verified by :';
    Sum_of__CaptionLbl: Label 'Sum of :';
    Narration__CaptionLbl: Label 'Narration :';
    Continued______CaptionLbl: Label 'Continued......';
    Applied_EntriesCaptionLbl: Label 'Applied Entries';
    Invoice_DateCaptionLbl: Label 'Invoice Date';
    Invoice_No_CaptionLbl: Label 'Invoice No.';
    Applied_AmountCaptionLbl: Label 'Applied Amount';
    Remaining_AmountCaptionLbl: Label 'Remaining Amount';
    Original_AmountCaptionLbl: Label 'Original Amount';
    decDebitTotal: Decimal;
    decAmtTotal: Decimal;
    CurrReport_PAGENOCaptionLbl: Label 'Page';
    Text026: Label 'ZERO';
    Text027: Label 'HUNDRED';
    Text028: Label 'AND';
    Text029: Label '%1 results in a written number that is too long.';
    Text030: Label '" is already applied to %1 %2 for customer %3."';
    Text031: Label '" is already applied to %1 %2 for vendor %3."';
    Text032: Label 'ONE';
    Text033: Label 'TWO';
    Text034: Label 'THREE';
    Text035: Label 'FOUR';
    Text036: Label 'FIVE';
    Text037: Label 'SIX';
    Text038: Label 'SEVEN';
    Text039: Label 'EIGHT';
    Text040: Label 'NINE';
    Text041: Label 'TEN';
    Text042: Label 'ELEVEN';
    Text043: Label 'TWELVE';
    Text044: Label 'THIRTEEN';
    Text045: Label 'FOURTEEN';
    Text046: Label 'FIFTEEN';
    Text047: Label 'SIXTEEN';
    Text048: Label 'SEVENTEEN';
    Text049: Label 'EIGHTEEN';
    Text050: Label 'NINETEEN';
    Text051: Label 'TWENTY';
    Text052: Label 'THIRTY';
    Text053: Label 'FORTY';
    Text054: Label 'FIFTY';
    Text055: Label 'SIXTY';
    Text056: Label 'SEVENTY';
    Text057: Label 'EIGHTY';
    Text058: Label 'NINETY';
    Text059: Label 'THOUSAND';
    Text060: Label 'MILLION';
    Text061: Label 'BILLION';
    Text16526: Label 'ZERO';
    GLentry1: Record "G/L Entry";
    BankTotal: Decimal;
    GL: Record "G/L Entry";
    DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    InvoiceStatus: Text;
    SO: Record "Sales Header";
    PO: Record "Purchase Header";
    CLE: Record "Cust. Ledger Entry";
    PurchInvHead: Record "Purch. Inv. Header";
    Descr: Text;
    SONo: Code[20];
    CustName: Text[100];
    TotalSOValue: Decimal;
    TotalPOValue: Decimal;
    TotalSOInvoicedValue: Decimal;
    TotalPaidForthatPO: Decimal;
    SalesInvHeader: Record "Sales Invoice Header";
    VLE: Record "Vendor Ledger Entry";
    VLEDesc: Text;
    TotalPaidbyCust: Decimal;
    procedure FindGLAccName("Source Type": Enum "Gen. Journal Source Type"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Text[50];
    var
        AccName: Text[50];
        VendLedgerEntry: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        Bank: Record "Bank Account";
        FALedgerEntry: Record "FA Ledger Entry";
        FA: Record "Fixed Asset";
        GLAccount: Record "G/L Account";
    begin
        if "Source Type" = "Source Type"::Vendor then if VendLedgerEntry.GET("Entry No.")then begin
                Vend.GET("Source No.");
                AccName:=Vend.Name;
            end
            else
            begin
                GLAccount.GET("G/L Account No.");
                AccName:=GLAccount.Name;
            end
        else if "Source Type" = "Source Type"::Customer then if CustLedgerEntry.GET("Entry No.")then begin
                    Cust.GET("Source No.");
                    AccName:=Cust.Name;
                end
                else
                begin
                    GLAccount.GET("G/L Account No.");
                    AccName:=GLAccount.Name;
                end
            else if "Source Type" = "Source Type"::"Bank Account" then if BankLedgerEntry.GET("Entry No.")then begin
                        Bank.GET("Source No.");
                        AccName:=Bank.Name;
                    end
                    else
                    begin
                        GLAccount.GET("G/L Account No.");
                        AccName:=GLAccount.Name;
                    end
                else if "Source Type" = "Source Type"::"Fixed Asset" then begin
                        FALedgerEntry.RESET;
                        FALedgerEntry.SETCURRENTKEY("G/L Entry No.");
                        FALedgerEntry.SETRANGE("G/L Entry No.", "Entry No.");
                        if FALedgerEntry.FINDFIRST then begin
                            FA.GET("Source No.");
                            AccName:=FA.Description;
                        end
                        else
                        begin
                            GLAccount.GET("G/L Account No.");
                            AccName:=GLAccount.Name;
                        end;
                    end
                    else
                    begin
                        GLAccount.GET("G/L Account No.");
                        AccName:=GLAccount.Name;
                    end;
        if "Source Type" = "Source Type"::" " then begin
            GLAccount.GET("G/L Account No.");
            AccName:=GLAccount.Name;
        end;
        exit(AccName);
    end;
    procedure FormatNoText(var NoText: array[2]of Text[80]; No: Decimal; CurrencyCode: Code[10]);
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        DecimalPosition: Decimal;
        OnesDec: Integer;
        TensDec: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex:=1;
        NoText[1]:='';
        GLSetup.GET;
        if No < 1 then AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else
            for Exponent:=4 downto 1 do begin
                PrintExponent:=false;
                Ones:=No div POWER(1000, Exponent - 1);
                Hundreds:=Ones div 100;
                Tens:=(Ones mod 100) div 10;
                Ones:=Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end
                else if(Tens * 10 + Ones) > 0 then AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1)then AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No:=No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            end;
        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        if GLSetup."Amount Rounding Precision" <> 0 then DecimalPosition:=1 / GLSetup."Amount Rounding Precision"
        else
            DecimalPosition:=1;
        AddToNoText(NoText, NoTextIndex, PrintExponent, (FORMAT(No * DecimalPosition) + '/' + FORMAT(DecimalPosition)));
        if CurrencyCode <> '' then AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    /*
        //O2Gen-Sushil Start
        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;
        
        IF CurrencyCode = '' THEN BEGIN
          IF TensDec >= 2 THEN BEGIN
            AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[TensDec]);
            IF OnesDec > 0 THEN
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[OnesDec]);
          END ELSE
            IF (TensDec * 10 + OnesDec) > 0 THEN
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[TensDec * 10 + OnesDec])
            ELSE
              AddToNoText(NoText,NoTextIndex,PrintExponent,Text16526);
        
        END ELSE BEGIN
          GLSetup.GET;
          IF GLSetup."Amount Rounding Precision" <> 0 THEN
            DecimalPosition := 1 / GLSetup."Amount Rounding Precision"
          ELSE
            DecimalPosition := 1;
          AddToNoText(NoText,NoTextIndex,PrintExponent,(FORMAT(No * DecimalPosition) + '/' + FORMAT(DecimalPosition)));
        END;
        //O2Gen-Sushil Stop
         */
    end;
    local procedure AddToNoText(var NoText: array[2]of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30]);
    begin
        PrintExponent:=true;
        while STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1])do begin
            NoTextIndex:=NoTextIndex + 1;
            if NoTextIndex > ARRAYLEN(NoText)then ERROR(Text029, AddText);
        end;
        NoText[NoTextIndex]:=DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;
    procedure InitTextVariable();
    begin
        OnesText[1]:=Text032;
        OnesText[2]:=Text033;
        OnesText[3]:=Text034;
        OnesText[4]:=Text035;
        OnesText[5]:=Text036;
        OnesText[6]:=Text037;
        OnesText[7]:=Text038;
        OnesText[8]:=Text039;
        OnesText[9]:=Text040;
        OnesText[10]:=Text041;
        OnesText[11]:=Text042;
        OnesText[12]:=Text043;
        OnesText[13]:=Text044;
        OnesText[14]:=Text045;
        OnesText[15]:=Text046;
        OnesText[16]:=Text047;
        OnesText[17]:=Text048;
        OnesText[18]:=Text049;
        OnesText[19]:=Text050;
        TensText[1]:='';
        TensText[2]:=Text051;
        TensText[3]:=Text052;
        TensText[4]:=Text053;
        TensText[5]:=Text054;
        TensText[6]:=Text055;
        TensText[7]:=Text056;
        TensText[8]:=Text057;
        TensText[9]:=Text058;
        ExponentText[1]:='';
        ExponentText[2]:=Text059;
        ExponentText[3]:=Text060;
        ExponentText[4]:=Text061;
    end;
    procedure FindApplnEntriesDtldtLedgEntry(CreateVendLedgEntry: Record "Vendor Ledger Entry"; var DtldVendLedgEntryTemp: Record "Detailed Vendor Ledg. Entry" temporary);
    var
        DtldVendLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntryTemp.DELETEALL; //Temporary variable
        DtldVendLedgEntry1.SETCURRENTKEY("Vendor Ledger Entry No.");
        DtldVendLedgEntry1.SETRANGE("Vendor Ledger Entry No.", CreateVendLedgEntry."Entry No.");
        DtldVendLedgEntry1.SETRANGE(Unapplied, false);
        if DtldVendLedgEntry1.FIND('-')then repeat if DtldVendLedgEntry1."Vendor Ledger Entry No." = DtldVendLedgEntry1."Applied Vend. Ledger Entry No." then begin
                    DtldVendLedgEntry2.INIT;
                    DtldVendLedgEntry2.SETCURRENTKEY("Applied Vend. Ledger Entry No.", "Entry Type");
                    DtldVendLedgEntry2.SETRANGE("Applied Vend. Ledger Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    DtldVendLedgEntry2.SETRANGE("Entry Type", DtldVendLedgEntry2."Entry Type"::Application);
                    DtldVendLedgEntry2.SETRANGE(Unapplied, false);
                    if DtldVendLedgEntry2.FIND('-')then repeat if DtldVendLedgEntry2."Vendor Ledger Entry No." <> DtldVendLedgEntry2."Applied Vend. Ledger Entry No." then begin
                                //DtldVendLedgEntry.SETCURRENTKEY("Entry No.");
                                //DtldVendLedgEntry.SETRANGE("Entry No.",DtldVendLedgEntry2."Vendor Ledger Entry No.");
                                //IF DtldVendLedgEntry.FIND('-') THEN BEGIN
                                DtldVendLedgEntryTemp:=DtldVendLedgEntry2;
                                DtldVendLedgEntryTemp.INSERT;
                            //END;
                            end;
                        until DtldVendLedgEntry2.NEXT = 0;
                end
                else
                begin
                    //DtldVendLedgEntry.SETCURRENTKEY("Entry No.");
                    //DtldVendLedgEntry.SETRANGE("Entry No.",DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    //IF DtldVendLedgEntry.FIND('-') THEN BEGIN
                    DtldVendLedgEntryTemp:=DtldVendLedgEntry1;
                    DtldVendLedgEntryTemp.INSERT;
                //END;
                end;
            until DtldVendLedgEntry1.NEXT = 0;
    end;
}
