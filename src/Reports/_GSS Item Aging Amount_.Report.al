report 60106 "GSS Item Aging Amount"
{
    // version GSS
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/Item Aging Amount.rdl';
    Caption = 'Item Aging Amount';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.")WHERE(Type=CONST(Inventory));
            RequestFilterFields = "No.", "Inventory Posting Group", "Statistics Group", "Location Filter";

            column(TodayFormatted; FORMAT(TODAY, 0, 4))
            {
            }
            column(CompanyName; COMPANYNAME)
            {
            }
            column(ItemTableCaptItemFilter; TABLECAPTION + ': ' + ItemFilter)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(PeriodStartDate21; FORMAT(PeriodStartDate[2] + 1))
            {
            }
            column(PeriodStartDate3; FORMAT(PeriodStartDate[3]))
            {
            }
            column(PeriodStartDate31; FORMAT(PeriodStartDate[3] + 1))
            {
            }
            column(PeriodStartDate4; FORMAT(PeriodStartDate[4]))
            {
            }
            column(PeriodStartDate41; FORMAT(PeriodStartDate[4] + 1))
            {
            }
            column(PeriodStartDate5; FORMAT(PeriodStartDate[5]))
            {
            }
            column(PeriodStartDate51; FORMAT(PeriodStartDate[5] + 1))
            {
            }
            column(PeriodStartDate6; FORMAT(PeriodStartDate[6]))
            {
            }
            column(PeriodStartDate61; FORMAT(PeriodStartDate[6] + 1))
            {
            }
            column(PeriodStartDate7; FORMAT(PeriodStartDate[7]))
            {
            }
            column(PrintLine; PrintLine)
            {
            }
            column(InvtValueRTC1; InvtValueRTC[1])
            {
            }
            column(InvtValueRTC2; InvtValueRTC[2])
            {
            }
            column(InvtValueRTC5; InvtValueRTC[5])
            {
            }
            column(InvtValueRTC4; InvtValueRTC[4])
            {
            }
            column(InvtValueRTC3; InvtValueRTC[3])
            {
            }
            column(InvtValueRTC6; InvtValueRTC[6])
            {
            }
            column(InvtValueRTC7; InvtValueRTC[7])
            {
            }
            column(TotalInvtValueRTC; TotalInvtValueRTC)
            {
            }
            column(InvtValue1_Item; InvtValue[1])
            {
            AutoFormatType = 1;
            }
            column(InvtValue2_Item; InvtValue[2])
            {
            AutoFormatType = 1;
            }
            column(InvtValue3_Item; InvtValue[3])
            {
            AutoFormatType = 1;
            }
            column(InvtValue4_Item; InvtValue[4])
            {
            AutoFormatType = 1;
            }
            column(InvtValue5_Item; InvtValue[5])
            {
            AutoFormatType = 1;
            }
            column(InvtValue6_Item; InvtValue[6])
            {
            }
            column(InvtValue7_Item; InvtValue[7])
            {
            }
            column(TotalInvtValue_Item; TotalInvtValue_Item)
            {
            AutoFormatType = 1;
            }
            column(ItemAgeCompositionValueCaption; ItemAgeCompositionValueCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(AfterCaption; AfterCaptionLbl)
            {
            }
            column(BeforeCaption; BeforeCaptionLbl)
            {
            }
            column(InventoryValueCaption; InventoryValueCaptionLbl)
            {
            }
            column(ItemDescriptionCaption; ItemDescriptionCaptionLbl)
            {
            }
            column(ItemNoCaption; ItemNoCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No."=FIELD("No."), "Location Code"=FIELD("Location Filter"), "Variant Code"=FIELD("Variant Filter"), "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code"=FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Item No.", Open)WHERE(Open=CONST(true));

                trigger OnAfterGetRecord();
                begin
                    if "Remaining Quantity" = 0 then CurrReport.SKIP;
                    PrintLine:=true;
                    CalcRemainingQty;
                    if Item."Costing Method" = Item."Costing Method"::Average then begin
                        TotalInvtValue_Item+=AverageCost * TotalInvtQty;
                        InvtValue[i]+=AverageCost * InvtQty[i];
                        TotalInvtValueRTC+=AverageCost * TotalInvtQty;
                        InvtValueRTC[i]+=AverageCost * InvtQty[i];
                    end
                    else
                    begin
                        CalcUnitCost;
                        TotalInvtValue_Item+=UnitCost * ABS(TotalInvtQty);
                        InvtValue[i]+=UnitCost * ABS(InvtQty[i]);
                        TotalInvtValueRTC+=UnitCost * ABS(TotalInvtQty);
                        InvtValueRTC[i]+=UnitCost * ABS(InvtQty[i]);
                    end end;
                trigger OnPreDataItem();
                begin
                    TotalInvtValue_Item:=0;
                    for i:=1 to 7 do InvtValue[i]:=0;
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number)WHERE(Number=CONST(1));

                column(TotalInvtValue_ItemLedgEntry; TotalInvtValue_Item)
                {
                AutoFormatType = 1;
                }
                column(InvtValue7_ItemLedgEntry; InvtValue[7])
                {
                }
                column(InvtValue6_ItemLedgEntry; InvtValue[6])
                {
                }
                column(InvtValue5_ItemLedgEntry; InvtValue[5])
                {
                AutoFormatType = 1;
                }
                column(InvtValue4_ItemLedgEntry; InvtValue[4])
                {
                AutoFormatType = 1;
                }
                column(InvtValue3_ItemLedgEntry; InvtValue[3])
                {
                AutoFormatType = 1;
                }
                column(InvtValue2_ItemLedgEntry; InvtValue[2])
                {
                AutoFormatType = 1;
                }
                column(InvtValue1_ItemLedgEntry; InvtValue[1])
                {
                AutoFormatType = 1;
                }
                column(Description_Item; Item.Description)
                {
                }
                column(No_Item; Item."No.")
                {
                }
            }
            trigger OnAfterGetRecord();
            begin
                if "Costing Method" = "Costing Method"::Average then ItemCostMgt.CalculateAverageCost(Item, AverageCost, AverageCostACY);
                PrintLine:=false;
            end;
            trigger OnPreDataItem();
            begin
            //itos   CurrReport.CREATETOTALS(InvtValue, TotalInvtValue_Item);
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

                    field(EndingDate; PeriodStartDate[7])
                    {
                        Caption = 'Ending Date';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if PeriodStartDate[5] = 0D then ERROR(Text002);
                        end;
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        Caption = 'Period Length';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if FORMAT(PeriodLength) = '' then EVALUATE(PeriodLength, '<0D>');
                        end;
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnOpenPage();
        begin
            if PeriodStartDate[5] = 0D then PeriodStartDate[5]:=CALCDATE('<CM>', WORKDATE);
            if FORMAT(PeriodLength) = '' then EVALUATE(PeriodLength, '<1M>');
        end;
    }
    labels
    {
    }
    trigger OnPreReport();
    var
        NegPeriodLength: DateFormula;
    begin
        CLEAR(ItemAgingUpdate);
        ItemAgingUpdate.USEREQUESTPAGE:=false;
        ItemAgingUpdate.RUNMODAL;
        ItemFilter:=Item.GETFILTERS;
        PeriodStartDate[8]:=99991231D;
        EVALUATE(NegPeriodLength, STRSUBSTNO('-%1', FORMAT(PeriodLength)));
        for i:=1 to 5 do PeriodStartDate[7 - i]:=CALCDATE(NegPeriodLength, PeriodStartDate[8 - i]);
    end;
    var Text002: Label 'Enter the ending date';
    ItemCostMgt: Codeunit ItemCostManagement;
    ItemFilter: Text;
    InvtValue: array[8]of Decimal;
    InvtValueRTC: array[8]of Decimal;
    InvtQty: array[8]of Decimal;
    UnitCost: Decimal;
    PeriodStartDate: array[8]of Date;
    PeriodLength: DateFormula;
    i: Integer;
    TotalInvtValue_Item: Decimal;
    TotalInvtValueRTC: Decimal;
    TotalInvtQty: Decimal;
    PrintLine: Boolean;
    AverageCost: Decimal;
    AverageCostACY: Decimal;
    ItemAgeCompositionValueCaptionLbl: Label 'Item Age Composition - Value';
    CurrReportPageNoCaptionLbl: Label 'Page';
    AfterCaptionLbl: Label 'After...';
    BeforeCaptionLbl: Label '...Before';
    InventoryValueCaptionLbl: Label 'Inventory Value';
    ItemDescriptionCaptionLbl: Label 'Description';
    ItemNoCaptionLbl: Label 'Item No.';
    TotalCaptionLbl: Label 'Total';
    ItemAgingUpdate: Report "Gss Item Aging Update";
    procedure CalcRemainingQty();
    var
        IAE: Record "Item Application Entry";
    begin
        with "Item Ledger Entry" do begin
            for i:=1 to 7 do InvtQty[i]:=0;
            TotalInvtQty:="Remaining Quantity";
            //GSS
            /* commented base code
            FOR i := 1 TO 5 DO
              IF ("Posting Date" > PeriodStartDate[i]) AND
                 ("Posting Date" <= PeriodStartDate[i + 1])
              THEN
                IF "Remaining Quantity" <> 0 THEN BEGIN
                  InvtQty[i] := "Remaining Quantity";
                  EXIT;
                END;
            */
            CLEAR(IAE);
            IAE.Reset();
            IAE.SETCURRENTKEY("Item Ledger Entry No.");
            IAE.SETRANGE("Item Ledger Entry No.", "Entry No.");
            if IAE.FINDFIRST then for i:=1 to 7 do if(IAE."GSSPurchase Date" > PeriodStartDate[i]) and (IAE."GSSPurchase Date" <= PeriodStartDate[i + 1])then if "Remaining Quantity" <> 0 then begin
                            InvtQty[i]:="Remaining Quantity";
                            exit;
                        end;
        //GSS
        end;
    end;
    procedure CalcUnitCost();
    var
        ValueEntry: Record "Value Entry";
    begin
        with ValueEntry do begin
            SETRANGE("Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
            UnitCost:=0;
            if FIND('-')then repeat if "Partial Revaluation" then SumUnitCost(UnitCost, "Cost Amount (Actual)" + "Cost Amount (Expected)", "Valued Quantity")
                    else
                        SumUnitCost(UnitCost, "Cost Amount (Actual)" + "Cost Amount (Expected)", "Item Ledger Entry".Quantity);
                until NEXT = 0;
        end;
    end;
    local procedure SumUnitCost(var UnitCost: Decimal; CostAmount: Decimal; Quantity: Decimal);
    begin
        UnitCost:=UnitCost + CostAmount / ABS(Quantity);
    end;
    procedure InitializeRequest(NewEndingDate: Date; NewPeriodLength: DateFormula);
    begin
        PeriodStartDate[7]:=NewEndingDate;
        PeriodLength:=NewPeriodLength;
    end;
}
