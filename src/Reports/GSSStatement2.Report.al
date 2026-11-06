report 60105 GSSStatement2
{
    // version NAVW17.10.00.36366
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/Statement2.rdl';
    Caption = 'Customer Statement';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Print Statements", "Currency Filter";

            column(CompanyInfo1Picture; CompanyInfo1.Picture)
            {
            }
            column(CompanyInfo2Picture; CompanyInfo2.Picture)
            {
            }
            column(CompanyInfo3Picture; CompanyInfo3.Picture)
            {
            }
            column(No_Cust; "No.")
            {
            }
            column(UserId; USERID)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number)WHERE(Number=CONST(1));
                PrintOnlyIfDetail = true;

                column(CustAddr1; CustAddr[1])
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                column(CustAddr2; CustAddr[2])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(CustAddr3; CustAddr[3])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(CustAddr4; CustAddr[4])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(CustAddr5; CustAddr[5])
                {
                }
                column(PhoneNo_CompanyInfo; CompanyInfo."Phone No.")
                {
                }
                column(CustAddr6; CustAddr[6])
                {
                }
                column(CompanyInfoEmail; CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfoHomePage; CompanyInfo."Home Page")
                {
                }
                column(VATRegNo_CompanyInfo; CompanyInfo."VAT Registration No.")
                {
                }
                column(GiroNo_CompanyInfo; CompanyInfo."Giro No.")
                {
                }
                column(BankName_CompanyInfo; CompanyInfo."Bank Name")
                {
                }
                column(BankAccNo_CompanyInfo; CompanyInfo."Bank Account No.")
                {
                }
                column(No1_Cust; Customer."No.")
                {
                }
                column(TodayFormatted; FORMAT(TODAY, 0, 4))
                {
                }
                column(StartDate; FORMAT(StartDate))
                {
                }
                column(EndDate; FORMAT(EndDate))
                {
                }
                column(LastStatmntNo_Cust; FORMAT(Customer."Last Statement No."))
                {
                }
                column(CustAddr7; CustAddr[7])
                {
                }
                column(CustAddr8; CustAddr[8])
                {
                }
                column(CompanyAddr7; CompanyAddr[7])
                {
                }
                column(CompanyAddr8; CompanyAddr[8])
                {
                }
                column(StatementCaption; StatementCaptionLbl)
                {
                }
                column(PhoneNo_CompanyInfoCaption; PhoneNo_CompanyInfoCaptionLbl)
                {
                }
                column(VATRegNo_CompanyInfoCaption; VATRegNo_CompanyInfoCaptionLbl)
                {
                }
                column(GiroNo_CompanyInfoCaption; GiroNo_CompanyInfoCaptionLbl)
                {
                }
                column(BankName_CompanyInfoCaption; BankName_CompanyInfoCaptionLbl)
                {
                }
                column(BankAccNo_CompanyInfoCaption; BankAccNo_CompanyInfoCaptionLbl)
                {
                }
                column(No1_CustCaption; No1_CustCaptionLbl)
                {
                }
                column(StartDateCaption; StartDateCaptionLbl)
                {
                }
                column(EndDateCaption; EndDateCaptionLbl)
                {
                }
                column(LastStatmntNo_CustCaption; LastStatmntNo_CustCaptionLbl)
                {
                }
                column(PostDate_DtldCustLedgEntriesCaption; PostDate_DtldCustLedgEntriesCaptionLbl)
                {
                }
                column(DocNo_DtldCustLedgEntriesCaption; DtldCustLedgEntries.FIELDCAPTION("Document No."))
                {
                }
                column(Desc_CustLedgEntry2Caption; CustLedgEntry2.FIELDCAPTION(Description))
                {
                }
                column(DueDate_CustLedgEntry2Caption; DueDate_CustLedgEntry2CaptionLbl)
                {
                }
                column(RemainAmtCustLedgEntry2Caption; CustLedgEntry2.FIELDCAPTION("Remaining Amount"))
                {
                }
                column(CustBalanceCaption; CustBalanceCaptionLbl)
                {
                }
                column(OriginalAmt_CustLedgEntry2Caption; CustLedgEntry2.FIELDCAPTION("Original Amount"))
                {
                }
                column(CompanyInfoHomepageCaption; CompanyInfoHomepageCaptionLbl)
                {
                }
                column(CompanyInfoEmailCaption; CompanyInfoEmailCaptionLbl)
                {
                }
                column(DocDateCaption; DocDateCaptionLbl)
                {
                }
                column(Total_Caption2; Total_CaptionLbl)
                {
                }
                column(UserEMail; UserEmail)
                {
                }
                column(CompanyPost; CompanyInfo."Post Code" + ', ' + CompanyInfo.City + '  Tel: ' + CompanyInfo."Phone No." + ' Fax: ' + CompanyInfo."Fax No.")
                {
                }
                column(CompanyCity; CompanyInfo.City)
                {
                }
                dataitem(CurrencyLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number)WHERE(Number=FILTER(1..));
                    PrintOnlyIfDetail = true;

                    dataitem(CustLedgEntryHdr; "Integer")
                    {
                        DataItemTableView = SORTING(Number)WHERE(Number=CONST(1));

                        column(Currency2Code_CustLedgEntryHdr; STRSUBSTNO(Text001, Currency2.Code))
                        {
                        }
                        column(StartBalance; StartBalance)
                        {
                        AutoFormatExpression = Currency2.Code;
                        AutoFormatType = 1;
                        }
                        column(CurrencyCode3; CurrencyCode3)
                        {
                        }
                        column(CustBalance_CustLedgEntryHdr; CustBalance)
                        {
                        }
                        column(PrintLine; PrintLine)
                        {
                        }
                        column(DtldCustLedgEntryType; FORMAT(DtldCustLedgEntries."Entry Type", 0, 2))
                        {
                        }
                        column(EntriesExists; EntriesExists)
                        {
                        }
                        column(CurrText; CurrText)
                        {
                        }
                        dataitem(DtldCustLedgEntries; "Detailed Cust. Ledg. Entry")
                        {
                            DataItemTableView = SORTING("Customer No.", "Posting Date", "Entry Type", "Currency Code");

                            column(SerialNo; SNo)
                            {
                            }
                            column(PostDate_DtldCustLedgEntries; FORMAT("Posting Date"))
                            {
                            }
                            column(DocNo_DtldCustLedgEntries; "Document No.")
                            {
                            }
                            column(Description; Description)
                            {
                            }
                            column(DueDate_DtldCustLedgEntries; FORMAT("Due Date"))
                            {
                            }
                            column(CurrCode_DtldCustLedgEntries; "Currency Code")
                            {
                            }
                            column(Amt_DtldCustLedgEntries; Amt)
                            {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            }
                            column(RemainAmt_DtldCustLedgEntries; Amount - "Remaining Amount")
                            {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            }
                            column(CustBalance; "Remaining Amount")
                            {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                            }
                            column(Currency2Code; ITOS_Currency2Code)
                            {
                            }
                            column(CustRefNo; CustRefNo)
                            {
                            }
                            column(DueDay; DueDay)
                            {
                            }
                            trigger OnAfterGetRecord();
                            begin
                                RecCustLedger.RESET;
                                RecCustLedger.SETRANGE(RecCustLedger."Document No.", DtldCustLedgEntries."Document No.");
                                if RecCustLedger.FIND('-')then begin
                                    CustRefNo:=RecCustLedger."External Document No.";
                                end;
                                // if "Posting Date" <> 0D then
                                //     DueDay := TODAY - "Posting Date"
                                Clear(DueDay);
                                if SkipReversedUnapplied(DtldCustLedgEntries) or (Amount = 0)then CurrReport.SKIP;
                                "Remaining Amount":=0;
                                PrintLine:=true;
                                case "Entry Type" of "Entry Type"::"Initial Entry": begin
                                    "Cust. Ledger Entry".GET("Cust. Ledger Entry No.");
                                    Description:="Cust. Ledger Entry".Description;
                                    "Due Date":="Cust. Ledger Entry"."Due Date";
                                    "Cust. Ledger Entry".SETRANGE("Date Filter", 0D, EndDate);
                                    "Cust. Ledger Entry".CALCFIELDS("Remaining Amount");
                                    "Remaining Amount":="Cust. Ledger Entry"."Remaining Amount";
                                    "Cust. Ledger Entry".SETRANGE("Date Filter");
                                end;
                                "Entry Type"::Application: begin
                                    DtldCustLedgEntries2.SETCURRENTKEY("Customer No.", "Posting Date", "Entry Type");
                                    DtldCustLedgEntries2.SETRANGE("Customer No.", "Customer No.");
                                    DtldCustLedgEntries2.SETRANGE("Posting Date", "Posting Date");
                                    DtldCustLedgEntries2.SETRANGE("Entry Type", "Entry Type"::Application);
                                    DtldCustLedgEntries2.SETRANGE("Transaction No.", "Transaction No.");
                                    DtldCustLedgEntries2.SETFILTER("Currency Code", '<>%1', "Currency Code");
                                    if DtldCustLedgEntries2.FINDFIRST then begin
                                        Description:=Text005;
                                        "Due Date":=0D;
                                    end
                                    else
                                        PrintLine:=false;
                                end;
                                "Entry Type"::"Payment Discount", "Entry Type"::"Payment Discount (VAT Excl.)", "Entry Type"::"Payment Discount (VAT Adjustment)", "Entry Type"::"Payment Discount Tolerance", "Entry Type"::"Payment Discount Tolerance (VAT Excl.)", "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)": begin
                                    Description:=Text006;
                                    "Due Date":=0D;
                                end;
                                "Entry Type"::"Payment Tolerance", "Entry Type"::"Payment Tolerance (VAT Excl.)", "Entry Type"::"Payment Tolerance (VAT Adjustment)": begin
                                    Description:=Text014;
                                    "Due Date":=0D;
                                end;
                                "Entry Type"::"Appln. Rounding", "Entry Type"::"Correction of Remaining Amount": begin
                                    Description:=Text007;
                                    "Due Date":=0D;
                                end;
                                end;
                                if "Remaining Amount" = 0 then CurrReport.SKIP;
                                if PrintLine then SNo+=1;
                                if PrintLine then begin
                                    if(DtldCustLedgEntries."Document Type" = DtldCustLedgEntries."Document Type"::Payment) or (DtldCustLedgEntries."Document Type" = DtldCustLedgEntries."Document Type"::" ")then begin
                                        Amt:=0;
                                    end
                                    else
                                    begin
                                        Amt:=DtldCustLedgEntries.Amount;
                                    end;
                                end;
                                if "Due Date" <> 0D then DueDay:=EndDate - "Due Date";
                                //
                                //IF PrintLine THEN
                                //CustBalance := CustBalance;
                                //ITOS-
                                if Currency2.Code = '' then begin
                                    GLSetup.TestField("LCY Code");
                                    ITOS_Currency2Code:=GLSetup."LCY Code";
                                end
                                else
                                    ITOS_Currency2Code:=Currency2.Code;
                            //ITOS+
                            end;
                            trigger OnPreDataItem();
                            begin
                                SETRANGE("Customer No.", Customer."No.");
                                SETRANGE("Posting Date", StartDate, EndDate);
                                SETRANGE("Currency Code", Currency2.Code);
                                if Currency2.Code = '' then begin
                                    GLSetup.TESTFIELD("LCY Code");
                                    CurrencyCode3:=GLSetup."LCY Code";
                                    RecCurr.RESET;
                                    RecCurr.SETRANGE(RecCurr.Code, CurrencyCode3);
                                    if RecCurr.FINDFIRST then begin
                                        CurrText:='All Amounts in ' + RecCurr.Description;
                                    end;
                                end
                                else
                                begin
                                    CurrencyCode3:=Currency2.Code;
                                end;
                            //SNo := 0;
                            end;
                        }
                    }
                    dataitem(CustLedgEntryFooter; "Integer")
                    {
                        DataItemTableView = SORTING(Number)WHERE(Number=CONST(1));

                        column(CurrencyCode3_CustLedgEntryFooter; CurrencyCode3)
                        {
                        }
                        column(Total_Caption; Total_CaptionLbl)
                        {
                        }
                        column(CustBalance_CustLedgEntryHdrFooter; CustBalance)
                        {
                        AutoFormatExpression = Currency2.Code;
                        AutoFormatType = 1;
                        }
                        column(EntriesExistsl_CustLedgEntryFooterCaption; EntriesExists)
                        {
                        }
                    }
                    dataitem(CustLedgEntry2; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Customer No."=FIELD("No.");
                        DataItemLinkReference = Customer;
                        DataItemTableView = SORTING("Customer No.", Open, Positive, "Due Date");

                        column(OverDueEntries; STRSUBSTNO(Text002, Currency2.Code))
                        {
                        }
                        column(RemainAmt_CustLedgEntry2; "Remaining Amount")
                        {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                        }
                        column(PostDate_CustLedgEntry2; FORMAT("Posting Date"))
                        {
                        }
                        column(DocNo_CustLedgEntry2; "Document No.")
                        {
                        }
                        column(Desc_CustLedgEntry2; Description)
                        {
                        }
                        column(DueDate_CustLedgEntry2; FORMAT("Due Date"))
                        {
                        }
                        column(OriginalAmt_CustLedgEntry2; "Original Amount")
                        {
                        AutoFormatExpression = "Currency Code";
                        }
                        column(CurrCode_CustLedgEntry2; ITOS_Currency2Code)
                        {
                        }
                        column(PrintEntriesDue; PrintEntriesDue)
                        {
                        }
                        column(Currency2Code_CustLedgEntry2; ITOS_Currency3Code)
                        {
                        }
                        column(CurrencyCode3_CustLedgEntry2; CurrencyCode3)
                        {
                        }
                        column(CustNo_CustLedgEntry2; "Customer No.")
                        {
                        }
                        trigger OnAfterGetRecord();
                        var
                            CustLedgEntry: Record "Cust. Ledger Entry";
                        begin
                            if IncludeAgingBand then if("Posting Date" > EndDate) and ("Due Date" >= EndDate)then CurrReport.SKIP;
                            CustLedgEntry:=CustLedgEntry2;
                            CustLedgEntry.SETRANGE("Date Filter", 0D, EndDate);
                            CustLedgEntry.CALCFIELDS("Remaining Amount");
                            "Remaining Amount":=CustLedgEntry."Remaining Amount";
                            if CustLedgEntry."Remaining Amount" = 0 then CurrReport.SKIP;
                            if IncludeAgingBand and ("Posting Date" <= EndDate)then UpdateBuffer(Currency2.Code, GetDate("Posting Date", "Due Date"), "Remaining Amount");
                            if "Due Date" >= EndDate then CurrReport.SKIP;
                            if Currency2.Code = '' then begin
                                GLSetup.TestField("LCY Code");
                                ITOS_Currency3Code:=GLSetup."LCY Code";
                            end
                            else
                                ITOS_Currency3Code:=Currency2.Code;
                        end;
                        trigger OnPreDataItem();
                        begin
                            CurrReport.CREATETOTALS("Remaining Amount");
                            if not IncludeAgingBand then SETRANGE("Due Date", 0D, EndDate - 1);
                            SETRANGE("Currency Code", Currency2.Code);
                            if(not PrintEntriesDue) and (not IncludeAgingBand)then CurrReport.BREAK;
                        end;
                    }
                    trigger OnAfterGetRecord();
                    begin
                        if Number = 1 then Currency2.FINDFIRST;
                        repeat if not IsFirstLoop then IsFirstLoop:=true
                            else if Currency2.NEXT = 0 then CurrReport.BREAK;
                            Cust2:=Customer;
                            Cust2.SETRANGE("Date Filter", 0D, StartDate - 1);
                            Cust2.SETRANGE("Currency Filter", Currency2.Code);
                            Cust2.CALCFIELDS("Net Change");
                            StartBalance:=Cust2."Net Change";
                            CustBalance:=Cust2."Net Change";
                            "Cust. Ledger Entry".SETCURRENTKEY("Customer No.", "Posting Date", "Currency Code");
                            "Cust. Ledger Entry".SETRANGE("Customer No.", Customer."No.");
                            "Cust. Ledger Entry".SETRANGE("Posting Date", 0D, EndDate);
                            "Cust. Ledger Entry".SETRANGE("Currency Code", Currency2.Code);
                            EntriesExists:="Cust. Ledger Entry".FINDFIRST;
                        until EntriesExists;
                        RecUser.RESET;
                        RecUser.SETRANGE(RecUser."User ID", USERID);
                        if RecUser.FINDFIRST then begin
                            UserEmail:=RecUser."E-Mail";
                        end;
                    end;
                    trigger OnPreDataItem();
                    begin
                        Customer.COPYFILTER("Currency Filter", Currency2.Code);
                    end;
                }
                dataitem(AgingBandLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number)WHERE(Number=FILTER(1..));

                    column(AgingDate1; FORMAT(AgingDate[1] + 1))
                    {
                    }
                    column(AgingDate2; FORMAT(AgingDate[2]))
                    {
                    }
                    column(AgingDate21; FORMAT(AgingDate[2] + 1))
                    {
                    }
                    column(AgingDate3; FORMAT(AgingDate[3]))
                    {
                    }
                    column(AgingDate31; FORMAT(AgingDate[3] + 1))
                    {
                    }
                    column(AgingDate4; FORMAT(AgingDate[4]))
                    {
                    }
                    column(AgingBandEndingDate; STRSUBSTNO(Text011, AgingBandEndingDate, PeriodLength, SELECTSTR(DateChoice + 1, Text013)))
                    {
                    }
                    column(AgingDate41; FORMAT(AgingDate[4] + 1))
                    {
                    }
                    column(AgingDate5; FORMAT(AgingDate[5]))
                    {
                    }
                    column(AgingBandBufCol1Amt; AgingBandBuf."Column 1 Amt.")
                    {
                    AutoFormatExpression = AgingBandBuf."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(AgingBandBufCol2Amt; AgingBandBuf."Column 2 Amt.")
                    {
                    AutoFormatExpression = AgingBandBuf."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(AgingBandBufCol3Amt; AgingBandBuf."Column 3 Amt.")
                    {
                    AutoFormatExpression = AgingBandBuf."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(AgingBandBufCol4Amt; AgingBandBuf."Column 4 Amt.")
                    {
                    AutoFormatExpression = AgingBandBuf."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(AgingBandBufCol5Amt; AgingBandBuf."Column 5 Amt.")
                    {
                    AutoFormatExpression = AgingBandBuf."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(AgingBandCurrencyCode; AgingBandCurrencyCode)
                    {
                    }
                    column(beforeCaption; beforeCaptionLbl)
                    {
                    }
                    trigger OnAfterGetRecord();
                    begin
                        if Number = 1 then begin
                            if not AgingBandBuf.FIND('-')then CurrReport.BREAK;
                        end
                        else if AgingBandBuf.NEXT = 0 then CurrReport.BREAK;
                        AgingBandCurrencyCode:=AgingBandBuf."Currency Code";
                        if AgingBandCurrencyCode = '' then AgingBandCurrencyCode:=GLSetup."LCY Code";
                    end;
                    trigger OnPreDataItem();
                    begin
                        if not IncludeAgingBand then CurrReport.BREAK;
                    end;
                }
            }
            trigger OnAfterGetRecord();
            begin
                AgingBandBuf.DELETEALL;
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                PrintLine:=false;
                Cust2:=Customer;
                COPYFILTER("Currency Filter", Currency2.Code);
                if PrintAllHavingBal then begin
                    if Currency2.FIND('-')then repeat Cust2.SETRANGE("Date Filter", 0D, EndDate);
                            Cust2.SETRANGE("Currency Filter", Currency2.Code);
                            Cust2.CALCFIELDS("Net Change");
                            PrintLine:=Cust2."Net Change" <> 0;
                        until(Currency2.NEXT = 0) or PrintLine;
                end;
                if(not PrintLine) and PrintAllHavingEntry then begin
                    "Cust. Ledger Entry".RESET;
                    "Cust. Ledger Entry".SETCURRENTKEY("Customer No.", "Posting Date");
                    "Cust. Ledger Entry".SETRANGE("Customer No.", "No.");
                    "Cust. Ledger Entry".SETRANGE("Posting Date", StartDate, EndDate);
                    COPYFILTER("Currency Filter", "Cust. Ledger Entry"."Currency Code");
                    PrintLine:="Cust. Ledger Entry".FINDFIRST;
                end;
                if not PrintLine then CurrReport.SKIP;
                FormatAddr.Customer(CustAddr, Customer);
                CurrReport.PAGENO:=1;
                /*
                IF NOT CurrReport.PREVIEW THEN BEGIN
                  LOCKTABLE;
                  FIND;
                  "Last Statement No." := "Last Statement No." + 1;
                  MODIFY;
                  COMMIT;
                END ELSE
                  "Last Statement No." := "Last Statement No." + 1;
                
                IF LogInteraction THEN
                  IF NOT CurrReport.PREVIEW THEN
                    SegManagement.LogDocument(
                      7,FORMAT("Last Statement No."),0,0,DATABASE::Customer,"No.","Salesperson Code",'',
                      Text003 + FORMAT("Last Statement No."),'');
                */
                //EBT commented
                IsFirstLoop:=false;
            end;
            trigger OnPreDataItem();
            begin
                VerifyDates;
                AgingBandEndingDate:=EndDate;
                CalcAgingBandDates;
                CompanyInfo.GET;
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                Currency2.Code:='';
                Currency2.INSERT;
                COPYFILTER("Currency Filter", Currency.Code);
                if Currency.FIND('-')then repeat Currency2:=Currency;
                        Currency2.INSERT;
                    until Currency.NEXT = 0;
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field("Start Date"; StartDate)
                    {
                        Caption = 'Start Date';
                        Visible = true;
                        ApplicationArea = All;
                    }
                    field("As on Date"; EndDate)
                    {
                        Caption = 'As on Date';
                        ApplicationArea = All;
                    }
                    field(ShowOverdueEntries; PrintEntriesDue)
                    {
                        Caption = 'Show Overdue Entries';
                        ApplicationArea = All;
                    }
                    group(Include)
                    {
                        Caption = 'Include';

                        field(IncludeAllCustomerswithLE; PrintAllHavingEntry)
                        {
                            Caption = 'Include All Customers with Ledger Entries';
                            MultiLine = true;
                            ApplicationArea = All;

                            trigger OnValidate();
                            begin
                                if not PrintAllHavingEntry then PrintAllHavingBal:=true;
                            end;
                        }
                        field(IncludeAllCustomerswithBalance; PrintAllHavingBal)
                        {
                            Caption = 'Include All Customers with a Balance';
                            MultiLine = true;
                            ApplicationArea = All;

                            trigger OnValidate();
                            begin
                                if not PrintAllHavingBal then PrintAllHavingEntry:=true;
                            end;
                        }
                        field(IncludeReversedEntries; PrintReversedEntries)
                        {
                            Caption = 'Include Reversed Entries';
                            ApplicationArea = All;
                        }
                        field(IncludeUnappliedEntries; PrintUnappliedEntries)
                        {
                            Caption = 'Include Unapplied Entries';
                            ApplicationArea = All;
                        }
                    }
                    group("Aging Band")
                    {
                        Caption = 'Aging Band';

                        field(IncludeAgingBand; IncludeAgingBand)
                        {
                            Caption = 'Include Aging Band';
                            ApplicationArea = All;
                        }
                        field(AgingBandPeriodLengt; PeriodLength)
                        {
                            Caption = 'Aging Band Period Length';
                            ApplicationArea = All;
                        }
                        field(AgingBandby; DateChoice)
                        {
                            Caption = 'Aging Band by';
                            OptionCaption = 'Due Date,Posting Date';
                            ApplicationArea = All;
                        }
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ApplicationArea = All;
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnOpenPage();
        begin
            InitRequestPageDataInternal;
        end;
    }
    labels
    {
    }
    trigger OnInitReport();
    begin
        GLSetup.GET;
        SalesSetup.GET;
        case SalesSetup."Logo Position on Documents" of SalesSetup."Logo Position on Documents"::"No Logo": ;
        SalesSetup."Logo Position on Documents"::Left: begin
            CompanyInfo1.GET;
            CompanyInfo1.CALCFIELDS(Picture);
        end;
        SalesSetup."Logo Position on Documents"::Center: begin
            CompanyInfo2.GET;
            CompanyInfo2.CALCFIELDS(Picture);
        end;
        SalesSetup."Logo Position on Documents"::Right: begin
            CompanyInfo3.GET;
            CompanyInfo3.CALCFIELDS(Picture);
        end;
        end;
        CompanyInfo3.GET;
        CompanyInfo3.CALCFIELDS(Picture);
        LogInteractionEnable:=true;
    end;
    trigger OnPreReport();
    begin
        InitRequestPageDataInternal;
        StartDate:=20010101D;
    //EndDate:=TODAY;
    end;
    var Text001: Label 'Entries %1';
    Text002: Label 'Overdue Entries %1';
    Text003: Label '"Statement "';
    GLSetup: Record "General Ledger Setup";
    SalesSetup: Record "Sales & Receivables Setup";
    CompanyInfo: Record "Company Information";
    CompanyInfo1: Record "Company Information";
    CompanyInfo2: Record "Company Information";
    CompanyInfo3: Record "Company Information";
    Cust2: Record Customer;
    Currency: Record Currency;
    Currency2: Record Currency temporary;
    //Language: Record Language;
    "Cust. Ledger Entry": Record "Cust. Ledger Entry";
    DtldCustLedgEntries2: Record "Detailed Cust. Ledg. Entry";
    AgingBandBuf: Record "Aging Band Buffer" temporary;
    PrintAllHavingEntry: Boolean;
    PrintAllHavingBal: Boolean;
    PrintEntriesDue: Boolean;
    PrintUnappliedEntries: Boolean;
    PrintReversedEntries: Boolean;
    PrintLine: Boolean;
    LogInteraction: Boolean;
    EntriesExists: Boolean;
    StartDate: Date;
    EndDate: Date;
    "Due Date": Date;
    CustAddr: array[8]of Text[100];
    CompanyAddr: array[8]of Text[100];
    Description: Text[100];
    StartBalance: Decimal;
    CustBalance: Decimal;
    "Remaining Amount": Decimal;
    FormatAddr: Codeunit "Format Address";
    SegManagement: Codeunit SegManagement;
    CurrencyCode3: Code[10];
    Text005: Label 'Multicurrency Application';
    Text006: Label 'Payment Discount';
    Text007: Label 'Rounding';
    PeriodLength: DateFormula;
    PeriodLength2: DateFormula;
    DateChoice: Option "Due Date", "Posting Date";
    AgingDate: array[5]of Date;
    Text008: Label 'You must specify the Aging Band Period Length.';
    AgingBandEndingDate: Date;
    Text010: Label 'You must specify Aging Band Ending Date.';
    Text011: Label 'Aged Summary by %1 (%2 by %3)';
    IncludeAgingBand: Boolean;
    Text012: Label 'Period Length is out of range.';
    AgingBandCurrencyCode: Code[10];
    Text013: Label 'Due Date,Posting Date';
    Text014: Label 'Application Writeoffs';
    [InDataSet]
    LogInteractionEnable: Boolean;
    Text036: Label '-%1', Comment = 'Negating the period length: %1 is the period length';
    StatementCaptionLbl: Label 'Statement of Account';
    PhoneNo_CompanyInfoCaptionLbl: Label 'Phone No.';
    VATRegNo_CompanyInfoCaptionLbl: Label 'VAT Registration No.';
    GiroNo_CompanyInfoCaptionLbl: Label 'Giro No.';
    BankName_CompanyInfoCaptionLbl: Label 'Bank';
    BankAccNo_CompanyInfoCaptionLbl: Label 'Account No.';
    No1_CustCaptionLbl: Label 'Customer No.';
    StartDateCaptionLbl: Label 'Starting Date';
    EndDateCaptionLbl: Label 'Ending Date';
    LastStatmntNo_CustCaptionLbl: Label 'Statement No.';
    PostDate_DtldCustLedgEntriesCaptionLbl: Label 'Posting Date';
    DueDate_CustLedgEntry2CaptionLbl: Label 'Due Date';
    CustBalanceCaptionLbl: Label 'Balance';
    beforeCaptionLbl: Label '..before';
    isInitialized: Boolean;
    CompanyInfoHomepageCaptionLbl: Label 'Home Page';
    CompanyInfoEmailCaptionLbl: Label 'E-Mail';
    DocDateCaptionLbl: Label 'Document Date';
    Total_CaptionLbl: Label 'Total';
    BlankStartDateErr: Label 'Start Date must have a value.';
    BlankEndDateErr: Label 'End Date must have a value.';
    StartDateLaterTheEndDateErr: Label 'Start date must be earlier than End date.';
    IsFirstLoop: Boolean;
    RecUser: Record "User Setup";
    UserEmail: Text[100];
    CustRefNo: Text[100];
    RecCustLedger: Record "Cust. Ledger Entry";
    SNo: Integer;
    CurrText: Text;
    DueDay: Integer;
    Amt: Decimal;
    RecCurr: Record Currency;
    ITOS_Currency2Code: Code[20];
    ITOS_Currency3Code: Code[20];
    local procedure GetDate(PostingDate: Date; DueDate: Date): Date;
    begin
        if DateChoice = DateChoice::"Posting Date" then exit(PostingDate);
        exit(DueDate);
    end;
    local procedure CalcAgingBandDates();
    begin
        if not IncludeAgingBand then exit;
        if AgingBandEndingDate = 0D then ERROR(Text010);
        if FORMAT(PeriodLength) = '' then ERROR(Text008);
        EVALUATE(PeriodLength2, STRSUBSTNO(Text036, PeriodLength));
        AgingDate[5]:=AgingBandEndingDate;
        AgingDate[4]:=CALCDATE(PeriodLength2, AgingDate[5]);
        AgingDate[3]:=CALCDATE(PeriodLength2, AgingDate[4]);
        AgingDate[2]:=CALCDATE(PeriodLength2, AgingDate[3]);
        AgingDate[1]:=CALCDATE(PeriodLength2, AgingDate[2]);
        if AgingDate[2] <= AgingDate[1]then ERROR(Text012);
    end;
    local procedure UpdateBuffer(CurrencyCode: Code[10]; Date: Date; Amount: Decimal);
    var
        I: Integer;
        GoOn: Boolean;
    begin
        AgingBandBuf.INIT;
        AgingBandBuf."Currency Code":=CurrencyCode;
        if not AgingBandBuf.FIND then AgingBandBuf.INSERT;
        I:=1;
        GoOn:=true;
        while(I <= 5) and GoOn do begin
            if Date <= AgingDate[I]then if I = 1 then begin
                    AgingBandBuf."Column 1 Amt.":=AgingBandBuf."Column 1 Amt." + Amount;
                    GoOn:=false;
                end;
            if Date <= AgingDate[I]then if I = 2 then begin
                    AgingBandBuf."Column 2 Amt.":=AgingBandBuf."Column 2 Amt." + Amount;
                    GoOn:=false;
                end;
            if Date <= AgingDate[I]then if I = 3 then begin
                    AgingBandBuf."Column 3 Amt.":=AgingBandBuf."Column 3 Amt." + Amount;
                    GoOn:=false;
                end;
            if Date <= AgingDate[I]then if I = 4 then begin
                    AgingBandBuf."Column 4 Amt.":=AgingBandBuf."Column 4 Amt." + Amount;
                    GoOn:=false;
                end;
            if Date <= AgingDate[I]then if I = 5 then begin
                    AgingBandBuf."Column 5 Amt.":=AgingBandBuf."Column 5 Amt." + Amount;
                    GoOn:=false;
                end;
            I:=I + 1;
        end;
        AgingBandBuf.MODIFY;
    end;
    procedure SkipReversedUnapplied(var DtldCustLedgEntries: Record "Detailed Cust. Ledg. Entry"): Boolean;
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        if PrintReversedEntries and PrintUnappliedEntries then exit(false);
        if not PrintUnappliedEntries then if DtldCustLedgEntries.Unapplied then exit(true);
        if not PrintReversedEntries then begin
            CustLedgEntry.GET(DtldCustLedgEntries."Cust. Ledger Entry No.");
            if CustLedgEntry.Reversed then exit(true);
        end;
        exit(false);
    end;
    procedure InitializeRequest(NewPrintEntriesDue: Boolean; NewPrintAllHavingEntry: Boolean; NewPrintAllHavingBal: Boolean; NewPrintReversedEntries: Boolean; NewPrintUnappliedEntries: Boolean; NewIncludeAgingBand: Boolean; NewPeriodLength: Text[30]; NewDateChoice: Option; NewLogInteraction: Boolean; NewStartDate: Date; NewEndDate: Date);
    begin
        InitRequestPageDataInternal;
        PrintEntriesDue:=NewPrintEntriesDue;
        PrintAllHavingEntry:=NewPrintAllHavingEntry;
        PrintAllHavingBal:=NewPrintAllHavingBal;
        PrintReversedEntries:=NewPrintReversedEntries;
        PrintUnappliedEntries:=NewPrintUnappliedEntries;
        IncludeAgingBand:=NewIncludeAgingBand;
        EVALUATE(PeriodLength, NewPeriodLength);
        DateChoice:=NewDateChoice;
        LogInteraction:=NewLogInteraction;
        StartDate:=NewStartDate;
        EndDate:=NewEndDate;
    end;
    procedure InitRequestPageDataInternal();
    begin
        if isInitialized then exit;
        isInitialized:=true;
        if(not PrintAllHavingEntry) and (not PrintAllHavingBal)then PrintAllHavingBal:=true;
        // LogInteraction := SegManagement.FindInteractTmplCode(7) <> '';
        LogInteractionEnable:=LogInteraction;
        if FORMAT(PeriodLength) = '' then EVALUATE(PeriodLength, '<1M+CM>');
    end;
    local procedure VerifyDates();
    begin
        /*
IF StartDate = 0D THEN
  ERROR(BlankStartDateErr);
IF EndDate = 0D THEN
  ERROR(BlankEndDateErr);
         */
        if StartDate > EndDate then ERROR(StartDateLaterTheEndDateErr);
    end;
}
