report 60183 "DC Invoice Booking Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/InvoiceBookingSummary.rdl';
    Caption = 'Invoice Booking Summary 2';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Sell-to Customer No.", "Salesperson Code";

            // DataItemTableView = WHERE(Status = FILTER(Released | "Pending Approval"),
            //"Document Type" = FILTER(Order));
            column(SONo; "Sales Header"."No.")
            {
            }
            column(CstName; "Sales Header"."Sell-to Customer Name")
            {
            }
            column(Amount; "Sales Header".Amount)
            {
            }
            column(SrNo; SrNo)
            {
            }
            column(WeekNum; WeekNum)
            {
            }
            column(MonthNum; MonthName)
            {
            }
            column(GP; ProfitLCY)
            {
            }
            column(Original_Profit__; ProfitPct)
            {
            }
            //  column(BacklogRev; "Sales Header"."Outstanding Amt") { }
            column(BackOrderAmt; BackOrderAmt)
            {
            }
            column(NameComp; CompInfo.Name)
            {
            }
            column(Logo; CompInfo.Picture)
            {
            }
            column(SP; "Sales Header"."Salesperson Code")
            {
            }
            column(SODate; Format("Sales Header"."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(CustPO; "Sales Header"."External Document No.")
            {
            }
            column(ProjDesc;'')
            {
            } //"Sales Header"."Project Description") { }
            column(DelDate; Format("Sales Header"."Shipment Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
            {
            }
            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
            {
            }
            column(AdminFields; AdminFields)
            {
            }
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(CompAddress; CompInfo.Address)
            {
            }
            column(PhoneFax;' Phone No. : ' + CompInfo."Phone No." + ' Fax No. : ' + CompInfo."Fax No.")
            {
            }
            trigger OnAfterGetRecord()
            var
                UseDate: Date;
                CurrExchRate: Record "Currency Exchange Rate";
                ItemRec: Record Item;
                ValuEntryRec: Record "Value Entry";
            begin
                if "Sales Header"."Currency Code" = '' then CurrFactor:=1
                else
                    CurrFactor:="Sales Header"."Currency Factor";
                CLEAR(BackLogGP);
                CLEAR(BackOrderAmt);
                WeekNum:=DATE2DWY("Sales Header"."Order Date", 2);
                MonthName:=FORMAT("Sales Header"."Order Date", 0, '<Month Text>');
                "Sales Header".CalcFields(Amount, "Amount Including VAT");
                if "Sales Header"."Currency Code" <> '' then if "Sales Header"."Posting Date" = 0D then UseDate:=WorkDate
                    else
                        UseDate:="Sales Header"."Posting Date";
                /*BackOrderAmt := CurrExchRate.ExchangeAmtFCYToLCY(
                            UseDate, "Sales Header"."Currency Code", "Sales Header".Amount, "Sales Header"."Currency Factor");
                BackLogGP := "Sales Header"."Original Profit"; */
                Clear(CostLCY);
                Clear(AmountLCY);
                Clear(ProfitLCY);
                Clear(ProfitPct);
                SalesInvLine.SetRange("Document No.", "Sales Header"."No.");
                SalesInvLine.SetFilter(Quantity, '>%1', 0);
                SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
                if SalesInvLine.Find('-')then begin
                    SrNo+=1;
                /* repeat
                        if ItemRec.Get(SalesInvLine."No.") then;
                        AmountLCY += (SalesInvLine.Quantity * SalesInvLine."Unit Price") / CurrFactor;
                        //  CostLCY += (SalesInvLine.Quantity * ItemRec."Unit Cost");// * SalesInvLine."Unit Cost (LCY)");
                        CostLCY += CostCalcMgt.CalcSalesInvLineCostLCY(SalesInvLine) + CostCalcMgt.CalcSalesInvLineNonInvtblCostAmt(SalesInvLine);
                    until SalesInvLine.Next() = 0; */
                end;
                //New Calc--Start
                ValuEntryRec.Reset();
                ValuEntryRec.SetRange("Document No.", "Sales Header"."No.");
                if ValuEntryRec.FindSet()then repeat AmountLCY+=ValuEntryRec."Sales Amount (Actual)";
                        CostLCY+=ValuEntryRec."Cost Amount (Actual)" * -1;
                    until ValuEntryRec.Next() = 0;
                BackOrderAmt:=AmountLCY;
                // if CostLCY > 0 then begin
                /* CustLedgEntry.SetCurrentKey("Document No.");
                CustLedgEntry.SetRange("Document No.", "Sales Header"."No.");
                CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
                CustLedgEntry.SetRange("Customer No.", "Sales Header"."Bill-to Customer No.");
                if CustLedgEntry.FindFirst() then
                    AmountLCY := CustLedgEntry."Sales (LCY)"; */
                ProfitLCY:=AmountLCY - CostLCY;
                if AmountLCY <> 0 then ProfitPct:=Round(100 * ProfitLCY / AmountLCY, 0.1);
                //  end;
                Clear(PD);
                SHRec.SetRange("No.", "Sales Header"."Order No.");
            // if SHRec.FindFirst() then
            //   PD := SHRec."Project Description";
            end;
            trigger OnPreDataItem()
            begin
                CLEAR(SrNo);
                "Sales Header".SETRANGE("Sales Header"."Posting Date", StartDate, EndDate);
                if not AdminFields then "Sales Header".SetFilter("Salesperson Code", UserSetup."Salespers./Purch. Code");
                if(StartDate = 0D) and (EndDate = 0D)then Error('Please Enter the Date Filter');
            end;
        }
        dataitem(CrMemoHdr; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "Sell-to Customer No.", "Salesperson Code";

            // DataItemTableView = WHERE(Status = FILTER(Released | "Pending Approval"),
            //"Document Type" = FILTER(Order));
            column(CM_SONo; CrMemoHdr."No.")
            {
            }
            column(CM_CstName; CrMemoHdr."Sell-to Customer Name")
            {
            }
            column(CM_Amount; CrMemoHdr.Amount)
            {
            }
            column(CM_SrNo; SrNo)
            {
            }
            column(CM_WeekNum; WeekNum)
            {
            }
            column(CM_MonthNum; MonthName)
            {
            }
            column(CM_GP; ProfitLCY)
            {
            }
            column(CM_Original_Profit__; ProfitPct * -1)
            {
            }
            //  column(BacklogRev; "Sales Header"."Outstanding Amt") { }
            column(CM_BackOrderAmt; BackOrderAmt)
            {
            }
            column(CM_NameComp; CompInfo.Name)
            {
            }
            column(CM_Logo; CompInfo.Picture)
            {
            }
            column(CM_SP; CrMemoHdr."Salesperson Code")
            {
            }
            column(CM_SODate; Format(CrMemoHdr."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(CM_CustPO; CrMemoHdr."External Document No.")
            {
            }
            column(CM_ProjDesc; PD)
            {
            } //"Sales Header"."Project Description") { }
            column(CM_DelDate; Format(CrMemoHdr."Shipment Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(CM_Shortcut_Dimension_1_Code; CrMemoHdr."Shortcut Dimension 1 Code")
            {
            }
            column(CM_Shortcut_Dimension_2_Code; CrMemoHdr."Shortcut Dimension 2 Code")
            {
            }
            trigger OnAfterGetRecord()
            var
                UseDate: Date;
                CurrExchRate: Record "Currency Exchange Rate";
                ItemRec: Record Item;
                ValuEntryRec: Record "Value Entry";
            begin
                if CrMemoHdr."Currency Code" = '' then CurrFactor:=1
                else
                    CurrFactor:=CrMemoHdr."Currency Factor";
                CLEAR(BackLogGP);
                CLEAR(BackOrderAmt);
                //  WeekNum := DATE2DWY(CrMemoHdr."Order Date", 2);
                // MonthName := FORMAT(CrMemoHdr."Order Date", 0, '<Month Text>');
                CrMemoHdr.CalcFields(Amount, "Amount Including VAT");
                if CrMemoHdr."Currency Code" <> '' then if CrMemoHdr."Posting Date" = 0D then UseDate:=WorkDate
                    else
                        UseDate:=CrMemoHdr."Posting Date";
                BackOrderAmt:=CurrExchRate.ExchangeAmtFCYToLCY(UseDate, CrMemoHdr."Currency Code", CrMemoHdr.Amount, CrMemoHdr."Currency Factor");
                // BackLogGP := CrMemoHdr."Original Profit";
                Clear(CostLCY);
                Clear(AmountLCY);
                Clear(ProfitLCY);
                Clear(ProfitPct);
                SalCrMemoLine.SetRange("Document No.", CrMemoHdr."No.");
                SalCrMemoLine.SetFilter(Quantity, '>%1', 0);
                SalCrMemoLine.SetRange(Type, SalesInvLine.Type::Item);
                if SalCrMemoLine.Find('-')then begin
                    SrNo+=1;
                /* repeat
                        if ItemRec.Get(SalCrMemoLine."No.") then;
                        AmountLCY += (SalCrMemoLine.Quantity * SalCrMemoLine."Unit Price") / CurrFactor;
                        //CostLCY += (SalCrMemoLine.Quantity * ItemRec."Unit Cost");// * SalCrMemoLine."Unit Cost (LCY)";
                        CostLCY += CostCalcMgt.CalcSalesCrMemoLineCostLCY(SalCrMemoLine) + CostCalcMgt.CalcSalesCrMemoLineNonInvtblCostAmt(SalCrMemoLine);
                    until SalCrMemoLine.Next() = 0; */
                end;
                ValuEntryRec.Reset();
                ValuEntryRec.SetRange("Document No.", CrMemoHdr."No.");
                if ValuEntryRec.FindSet()then repeat AmountLCY+=ValuEntryRec."Sales Amount (Actual)" * -1;
                        CostLCY+=ValuEntryRec."Cost Amount (Actual)";
                    until ValuEntryRec.Next() = 0;
                BackOrderAmt:=AmountLCY;
                // if CostLCY > 0 then begin
                /* CustLedgEntry.SetCurrentKey("Document No.");
                CustLedgEntry.SetRange("Document No.", CrMemoHdr."No.");
                CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::"Credit Memo");
                CustLedgEntry.SetRange("Customer No.", CrMemoHdr."Bill-to Customer No.");
                if CustLedgEntry.FindFirst() then
                    AmountLCY := CustLedgEntry."Sales (LCY)"; */
                ProfitLCY:=AmountLCY - CostLCY;
                if AmountLCY <> 0 then ProfitPct:=Round(100 * ProfitLCY / AmountLCY, 0.1);
                //  end;
                Clear(PD);
                SHRec.SetRange("No.", CrMemoHdr."Pre-Assigned No.");
                if SHRec.FindFirst()then PD:=''; //SHRec."Project Description";
            end;
            trigger OnPreDataItem()
            begin
                //CLEAR(SrNo);
                CrMemoHdr.SETRANGE(CrMemoHdr."Posting Date", StartDate, EndDate);
                if not AdminFields then CrMemoHdr.SetFilter("Salesperson Code", UserSetup."Salespers./Purch. Code");
            // if (StartDate = 0D) and (EndDate = 0D) then
            //  Error('Please Enter the Date Filter');
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(CompInfo.Picture);
        if Usersetup.Get(UserId)then // if Usersetup."Reports Admin" then
            AdminFields:=true // else
    //  AdminFields := false;
    END;
    VAR WeekNum: Integer;
    MonthName: Text;
    BrandName: Text;
    SrNo: Integer;
    BackLogGP: Decimal;
    DimSetEntry: Record 480;
    AsofDate: Date;
    //SalesLine: Record 37;
    BackOrderAmt: Decimal;
    LineAmt: Decimal;
    CompInfo: Record 79;
    StartDate: Date;
    EndDate: Date;
    UserSetup: Record "User Setup";
    AdminFields: Boolean;
    SalesInvLine: Record "Sales Invoice Line";
    SalCrMemoLine: Record "Sales Cr.Memo Line";
    CostLCY: Decimal;
    CustLedgEntry: Record "Cust. Ledger Entry";
    AmountLCY: Decimal;
    ProfitPct: Decimal;
    ProfitLCY: Decimal;
    SHRec: Record "Sales Header";
    PD: Text[250];
    CurrFactor: Decimal;
    CostCalcMgt: Codeunit "Cost Calculation Management";
}
