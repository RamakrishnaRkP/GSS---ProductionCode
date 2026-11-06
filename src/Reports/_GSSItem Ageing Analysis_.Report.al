report 60121 "GSSItem Ageing Analysis"
{
    Caption = 'Item Ageing Analysis';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/ItemAgeingAnalysis2.rdl';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Item No.");
            RequestFilterFields = "Item No.";

            column(CompanyName; CompanyName)
            {
            }
            column(Unitcost; Item."Unit Cost")
            {
            }
            column(ItemDescription; Item.Description)
            {
            }
            column(L1Qty; L1Qty)
            {
            }
            column(L2Qty; L2Qty)
            {
            }
            column(L3Qty; L3Qty)
            {
            }
            column(L4Qty; L4Qty)
            {
            }
            column(L5Qty; L5Qty)
            {
            }
            column(L1Val; L1Val)
            {
            }
            column(L2Val; L2Val)
            {
            }
            column(L3Val; L3Val)
            {
            }
            column(L4Val; L4Val)
            {
            }
            column(L5Val; L5Val)
            {
            }
            column(ItemNo; "Item Ledger Entry"."Item No.")
            {
            }
            column(Getfilters; "Item Ledger Entry".GetFilters)
            {
            }
            column(AsofDate; AsofDate)
            {
            }
            column(L1Days; L1DaysCaption)
            {
            }
            column(L2Days; L2DaysCaption)
            {
            }
            column(L3Days; L3DaysCaption)
            {
            }
            column(L4Days; L4DaysCaption)
            {
            }
            column(L5Days; L5DaysCaption)
            {
            }
            column(L1Label; L1Label)
            {
            }
            column(L2Label; L2Label)
            {
            }
            column(L3Label; L3Label)
            {
            }
            column(L4Label; L4Label)
            {
            }
            column(L5Label; L5Label)
            {
            }
            column(L1ValTot; L1ValTot)
            {
            }
            column(L2ValTot; L2ValTot)
            {
            }
            column(L3ValTot; L3ValTot)
            {
            }
            column(L4ValTot; L4ValTot)
            {
            }
            column(L5ValTot; L5ValTot)
            {
            }
            column(L1QtyTot; L1QtyTot)
            {
            }
            column(L2QtyTot; L2QtyTot)
            {
            }
            column(L3QtyTot; L3QtyTot)
            {
            }
            column(L4QtyTot; L4QtyTot)
            {
            }
            column(L5QtyTot; L5QtyTot)
            {
            }
            column(ShipDate; Format(ShipDate))
            {
            }
            column(MrnDate; Format(MrnDate))
            {
            }
            trigger OnAfterGetRecord()
            begin
                Clear(Item);
                Clear(ItemRetailPrice);
                if Item.Get("Item No.")then;
                //IF NOT Item.Repeated THEN BEGIN   //APNT-T001212
                /*Store.RESET;
                Store.SETRANGE("Location Code","Location Code");
                IF Store.FINDFIRST THEN BEGIN
                  StorePriceGroup.RESET;
                  StorePriceGroup.SETCURRENTKEY(Store,"Price Group Code");
                  StorePriceGroup.SETRANGE(Store,Store."No.");
                  IF StorePriceGroup.FINDFIRST THEN
                    ItemRetailPrice := RetailPrice.GetValidRetailPrice2("Location Code",Item."No.",TODAY,TIME,Item."Base Unit of Measure",
                                         "Variant Code",'',Store."Currency Code",StorePriceGroup."Price Group Code",'','','');
                END;
                 */
                Clear(L1Qty);
                Clear(ICL1Qty);
                Clear(PGL1Qty);
                Clear(NetL1Qty);
                Clear(L1Val);
                Clear(ICL1Val);
                Clear(PGL1Val);
                Clear(NetL1Val);
                Clear(L2Qty);
                Clear(ICL2Qty);
                Clear(PGL2Qty);
                Clear(NetL2Qty);
                Clear(L2Val);
                Clear(ICL2Val);
                Clear(PGL2Val);
                Clear(NetL2Val);
                Clear(L3Qty);
                Clear(ICL3Qty);
                Clear(PGL3Qty);
                Clear(NetL3Qty);
                Clear(L3Val);
                Clear(ICL3Val);
                Clear(PGL3Val);
                Clear(NetL3Val);
                Clear(L4Qty);
                Clear(ICL4Qty);
                Clear(PGL4Qty);
                Clear(NetL4Qty);
                Clear(L4Val);
                Clear(ICL4Val);
                Clear(PGL4Val);
                Clear(NetL4Val);
                Clear(L5Qty);
                Clear(ICL5Qty);
                Clear(PGL5Qty);
                Clear(NetL5Qty);
                Clear(L5Val);
                Clear(ICL5Val);
                Clear(PGL5Val);
                Clear(NetL5Val);
                CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                Clear(AppQty);
                ItemApplEntry.Reset;
                ItemApplEntry.SetRange("Item Ledger Entry No.", "Entry No.");
                if ItemApplEntry.FindFirst then begin
                    repeat AppQty+=ItemApplEntry.Quantity;
                        if ItemApplEntry."GSSPurchase Date" in[L1ToDate .. L1FromDate]then begin
                            L1Qty+=ItemApplEntry.Quantity;
                            ICL1Qty+=ItemApplEntry.Quantity;
                            PGL1Qty+=ItemApplEntry.Quantity;
                            NetL1Qty+=ItemApplEntry.Quantity;
                            if Quantity <> 0 then begin
                                // MESSAGE('%1',"Item Ledger Entry"."Cost Amount (Actual)");
                                // MESSAGE('%1',"Item Ledger Entry".Quantity);
                                //MESSAGE('%1',ItemApplEntry.Quantity);
                                L1Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                ICL1Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                PGL1Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                NetL1Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                            end;
                        end;
                        if ItemApplEntry."GSSPurchase Date" in[L2ToDate .. L2FromDate]then begin
                            L2Qty+=ItemApplEntry.Quantity;
                            ICL2Qty+=ItemApplEntry.Quantity;
                            PGL2Qty+=ItemApplEntry.Quantity;
                            NetL2Qty+=ItemApplEntry.Quantity;
                            if Quantity <> 0 then begin
                                L2Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                ICL2Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                PGL2Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                NetL2Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                            end;
                        end;
                        if ItemApplEntry."GSSPurchase Date" in[L3ToDate .. L3FromDate]then begin
                            L3Qty+=ItemApplEntry.Quantity;
                            ICL3Qty+=ItemApplEntry.Quantity;
                            PGL3Qty+=ItemApplEntry.Quantity;
                            NetL3Qty+=ItemApplEntry.Quantity;
                            if Quantity <> 0 then begin
                                L3Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                ICL3Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                PGL3Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                NetL3Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                            end;
                        end;
                        if ItemApplEntry."GSSPurchase Date" in[L4ToDate .. L4FromDate]then begin
                            L4Qty+=ItemApplEntry.Quantity;
                            ICL4Qty+=ItemApplEntry.Quantity;
                            PGL4Qty+=ItemApplEntry.Quantity;
                            NetL4Qty+=ItemApplEntry.Quantity;
                            if Quantity <> 0 then begin
                                L4Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                ICL4Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                PGL4Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                NetL4Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                            end;
                        end;
                        if ItemApplEntry."GSSPurchase Date" in[20010101D .. L5FromDate]then begin
                            L5Qty+=ItemApplEntry.Quantity;
                            ICL5Qty+=ItemApplEntry.Quantity;
                            PGL5Qty+=ItemApplEntry.Quantity;
                            NetL5Qty+=ItemApplEntry.Quantity;
                            if Quantity <> 0 then begin
                                L5Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                ICL5Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                PGL5Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                NetL5Val+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                            end;
                        end;
                        if(ItemApplEntry."GSSPurchase Date" in[(AsofDate + 1) .. 29990101D]) or (ItemApplEntry."GSSPurchase Date" = 0D)then begin
                            NegativeSales+=ItemApplEntry.Quantity;
                            ICNegativeSales+=ItemApplEntry.Quantity;
                            PGNegativeSales+=ItemApplEntry.Quantity;
                            NetNegativeSales+=ItemApplEntry.Quantity;
                            if Quantity <> 0 then begin
                                NegativeSalesValue+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                ICNegativeSalesValue+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                PGNegativeSalesValue+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                NetNegativeSalesValue+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                L3NegativeSalesValue+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                                L4NegativeSalesValue+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                            end;
                        end;
                    until ItemApplEntry.Next = 0;
                    if(AppQty <> Quantity) and (AppQty <> 0)then begin
                        NegativeSales+=(Quantity - AppQty);
                        ICNegativeSales+=(Quantity - AppQty);
                        PGNegativeSales+=(Quantity - AppQty);
                        NetNegativeSales+=(Quantity - AppQty);
                        if Quantity <> 0 then begin
                            NegativeSalesValue+=((("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity) * (Quantity - AppQty));
                            ICNegativeSalesValue+=((("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity) * (Quantity - AppQty));
                            PGNegativeSalesValue+=((("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity) * (Quantity - AppQty));
                            NetNegativeSalesValue+=((("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity) * (Quantity - AppQty));
                            L3NegativeSalesValue+=((("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity) * (Quantity - AppQty));
                            L4NegativeSalesValue+=((("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity) * (Quantity - AppQty));
                        end;
                    end;
                end
                else
                begin
                    NegativeSales+=ItemApplEntry.Quantity;
                    ICNegativeSales+=ItemApplEntry.Quantity;
                    PGNegativeSales+=ItemApplEntry.Quantity;
                    NetNegativeSales+=ItemApplEntry.Quantity;
                    if Quantity <> 0 then begin
                        NegativeSalesValue+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                        ICNegativeSalesValue+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                        PGNegativeSalesValue+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                        NetNegativeSalesValue+=ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / Quantity);
                    //L3NegativeSalesValue += ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / "Quantity");
                    //L4NegativeSalesValue += ItemApplEntry.Quantity * (("Cost Amount (Actual)" + "Cost Amount (Expected)") / "Quantity");
                    end;
                end;
                /*CLEAR(Barcodes);
                Barcodes.RESET;
                Barcodes.SETCURRENTKEY("Item No.","Variant Code","Unit of Measure Code");
                Barcodes.SETRANGE("Item No.","Item No.");
                Barcodes.SETRANGE("Unit of Measure Code","Unit of Measure Code");
                IF Barcodes.FINDFIRST THEN;
                END; //APNT-T001212
                */
                L1ValTot+=L1Val;
                L2ValTot+=L2Val;
                L3ValTot+=L3Val;
                L4ValTot+=L4Val;
                L5ValTot+=L5Val;
                L1QtyTot+=L1Qty;
                L2QtyTot+=L2Qty;
                L3QtyTot+=L3Qty;
                L4QtyTot+=L4Qty;
                L5QtyTot+=L5Qty;
                Clear(ShipDate);
                SalesShipmentLine.Reset;
                SalesShipmentLine.SetRange(SalesShipmentLine."No.", "Item No.");
                if SalesShipmentLine.FindLast then ShipDate:=SalesShipmentLine."Posting Date";
                Clear(MrnDate);
                Clear(ILEENT);
                ILE.Reset;
                ILE.SetRange("Item No.");
                ILE.SetRange("Item No.", "Item No.");
                ILE.SetRange(ILE."Entry Type", ILE."Entry Type"::Purchase);
                if ILE.FindLast then ILEENT:=ILE."Entry No.";
                ItemApp2.Reset;
                ItemApp2.SetRange(ItemApp2."Inbound Item Entry No.", ILEENT);
                if ItemApp2.FindLast then MrnDate:=ItemApp2."GSSPurchase Date";
            end;
            trigger OnPreDataItem()
            begin
                Clear(NetL1Qty);
                Clear(NetL2Qty);
                Clear(NetL3Qty);
                Clear(NetL4Qty);
                Clear(NetL5Qty);
                Clear(NetNegativeSales);
                Clear(NetClosingStock);
                Clear(NetL1Val);
                Clear(NetL2Val);
                Clear(NetL3Val);
                Clear(NetL4Val);
                Clear(NetL5Val);
                Clear(NetClosingStockValue);
                if AsofDate = 0D then Error('As of Date cannot be blank.');
                ItemApplEntry.Reset;
                ItemApplEntry.SetCurrentKey("Item Ledger Entry No.");
                ILE.Reset;
                ILE.SetRange(ILE."Entry Type", ILE."Entry Type"::Purchase);
                SetRange("Posting Date", 0D, AsofDate);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                field("As of Date"; AsofDate)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        L1FromDate:=AsofDate;
                        L1ToDate:=CalcDate(LEVELI, AsofDate);
                        L1Label:=Format(L1FromDate, 0, '<Day>.<Month Text,3>.<year>') + ' to ' + Format(L1ToDate, 0, '<Day>.<Month Text,3>.<year>');
                        L2FromDate:=L1ToDate - 1;
                        L2ToDate:=CalcDate(LEVELII, L2FromDate);
                        L2Label:=Format(L2FromDate, 0, '<Day>.<Month Text,3>.<year>') + ' to ' + Format(L2ToDate, 0, '<Day>.<Month Text,3>.<year>');
                        L3FromDate:=L2ToDate - 1;
                        L3ToDate:=CalcDate(LEVELIII, L3FromDate);
                        L3Label:=Format(L3FromDate, 0, '<Day>.<Month Text,3>.<year>') + ' to ' + Format(L3ToDate, 0, '<Day>.<Month Text,3>.<year>');
                        L4FromDate:=L3ToDate - 1;
                        L4ToDate:=CalcDate(LEVELIV, L4FromDate);
                        L4Label:=Format(L4FromDate, 0, '<Day>.<Month Text,3>.<year>') + ' to ' + Format(L4ToDate, 0, '<Day>.<Month Text,3>.<year>');
                        L5FromDate:=L4ToDate - 1;
                        L5ToDate:=CalcDate(LEVELV, L5FromDate);
                        L5Label:='Over ' + Format(L5FromDate, 0, '<Day>.<Month Text,3>.<year>');
                        //L5Label := FORMAT(L5FromDate,0,'<Day>.<Month Text,3>.<year>') + ' to ' + FORMAT(L5ToDate,0,'<Day>.<Month Text,3>.<year>');
                        L6FromDate:=L5ToDate - 1;
                        ClosingStockLabel:=Format(AsofDate, 0, '<Day>-<month text,3>-<year>');
                        CalculateDates;
                    end;
                }
                field(LEVELI; LEVELI)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CalculateDates;
                    end;
                }
                field(L1FromDate; L1FromDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(L1ToDate; L1ToDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(L1DaysCaption; L1DaysCaption)
                {
                    ApplicationArea = All;
                    Caption = 'No. Of Days';
                    Editable = false;
                }
                field(LEVEL2; LEVELII)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CalculateDates;
                    end;
                }
                field(L2FromDate; L2FromDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(L2ToDate; L2ToDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(L2DaysCaption; L2DaysCaption)
                {
                    ApplicationArea = All;
                    Caption = 'No. Of Days';
                    Editable = false;
                }
                field(LEVEL3; LEVELIII)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CalculateDates;
                    end;
                }
                field(L3FromDate; L3FromDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(L3ToDate; L3ToDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(L3DaysCaption; L3DaysCaption)
                {
                    ApplicationArea = All;
                    Caption = 'No. Of Days';
                    Editable = false;
                }
                field(LEVEL4; LEVELIV)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CalculateDates;
                    end;
                }
                field(L4FromDate; L4FromDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(L4ToDate; L4ToDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(L4DaysCaption; L4DaysCaption)
                {
                    ApplicationArea = All;
                    Caption = 'No. Of Days';
                    Editable = false;
                }
                field(LEVELV; LEVELV)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CalculateDates;
                    end;
                }
                field(L5FromDate; L5FromDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(L5ToDate; L5ToDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(L5DaysCaption; L5DaysCaption)
                {
                    ApplicationArea = All;
                    Caption = 'No. Of Days';
                    Editable = false;
                }
            }
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        AsofDate:=WorkDate;
        if Format(LEVELI) = '' then Evaluate(LEVELI, '-90D');
        if Format(LEVELII) = '' then Evaluate(LEVELII, '-90D');
        if Format(LEVELIII) = '' then Evaluate(LEVELIII, '-185D');
        if Format(LEVELIV) = '' then Evaluate(LEVELIV, '-365D');
        if Format(LEVELV) = '' then Evaluate(LEVELV, '-365D');
        if L1FromDate = 0D then L1FromDate:=AsofDate;
        L1ToDate:=CalcDate(LEVELI, AsofDate);
        L1Label:=Format(L1FromDate, 0, '<Day>.<Month Text,3>.<year>') + ' to ' + Format(L1ToDate, 0, '<Day>.<Month Text,3>.<year>');
        L2FromDate:=L1ToDate - 1;
        L2ToDate:=CalcDate(LEVELII, L2FromDate);
        L2Label:=Format(L2FromDate, 0, '<Day>.<Month Text,3>.<year>') + ' to ' + Format(L2ToDate, 0, '<Day>.<Month Text,3>.<year>');
        L3FromDate:=L2ToDate - 1;
        L3ToDate:=CalcDate(LEVELIII, L3FromDate);
        L3Label:=Format(L3FromDate, 0, '<Day>.<Month Text,3>.<year>') + ' to ' + Format(L3ToDate, 0, '<Day>.<Month Text,3>.<year>');
        L4FromDate:=L3ToDate - 1;
        L4ToDate:=CalcDate(LEVELIV, L4FromDate);
        L4Label:=Format(L4FromDate, 0, '<Day>.<Month Text,3>.<year>') + ' to ' + Format(L4ToDate, 0, '<Day>.<Month Text,3>.<year>');
        L5FromDate:=L4ToDate - 1;
        L5ToDate:=CalcDate(LEVELV, L5FromDate);
        L5Label:='Over ' + Format(L5FromDate, 0, '<Day>.<Month Text,3>.<year>');
        // + ' to ' + FORMAT(L5ToDate,0,'<Day>.<Month Text,3>.<year>');
        L6FromDate:=L5ToDate - 1;
        ClosingStockLabel:=Format(AsofDate, 0, '<Day>-<month text,3>-<year>');
        CalculateDates;
        PrintSummary:=true;
        Clear(L1ValTot);
        Clear(L2ValTot);
        Clear(L3ValTot);
        Clear(L4ValTot);
        Clear(L5ValTot);
        Clear(L1QtyTot);
        Clear(L2QtyTot);
        Clear(L3QtyTot);
        Clear(L4QtyTot);
        Clear(L5QtyTot);
    end;
    trigger OnPreReport()
    begin
        Clear(ItemAgingUpdate);
        ItemAgingUpdate.USEREQUESTPAGE:=false;
        ItemAgingUpdate.RUNMODAL;
        //210916-
        CalculateDates;
    /*
        AsofDate := WORKDATE;
        
        IF L1FromDate = 0D THEN
          L1FromDate := AsofDate;
        
        L1ToDate := CALCDATE(LEVELI,AsofDate);
        L1Label := FORMAT(L1FromDate,0,'<Day>.<Month Text,3>.<year>') + ' to ' + FORMAT(L1ToDate,0,'<Day>.<Month Text,3>.<year>');
        
        L2FromDate := L1ToDate - 1;
        L2ToDate := CALCDATE(LEVELII,L2FromDate);
        L2Label := FORMAT(L2FromDate,0,'<Day>.<Month Text,3>.<year>') + ' to ' + FORMAT(L2ToDate,0,'<Day>.<Month Text,3>.<year>');
        
        L3FromDate := L2ToDate - 1;
        L3ToDate := CALCDATE(LEVELIII,L3FromDate);
        L3Label := FORMAT(L3FromDate,0,'<Day>.<Month Text,3>.<year>') + ' to ' + FORMAT(L3ToDate,0,'<Day>.<Month Text,3>.<year>');
        
        L4FromDate := L3ToDate - 1;
        L4ToDate := CALCDATE(LEVELIV,L4FromDate);
        L4Label := FORMAT(L4FromDate,0,'<Day>.<Month Text,3>.<year>') + ' to ' + FORMAT(L4ToDate,0,'<Day>.<Month Text,3>.<year>');
        
        L5FromDate := L4ToDate - 1;
        L5ToDate := CALCDATE(LEVELV,L5FromDate);
        L5Label := 'Over ' + FORMAT(L5FromDate,0,'<Day>.<Month Text,3>.<year>');
        
        //L5Label := FORMAT(L5FromDate,0,'<Day>.<Month Text,3>.<year>') + ' to ' + FORMAT(L5ToDate,0,'<Day>.<Month Text,3>.<year>');
        
        L6FromDate := L5ToDate - 1;
        ClosingStockLabel := FORMAT(AsofDate,0,'<Day>-<month text,3>-<year>');
        
        {
        L1Days := L1ToDate - AsofDate;
        L2Days := L2ToDate - AsofDate;
        L3Days := L3ToDate - AsofDate;
        L4Days := L4ToDate - AsofDate;
        L5Days := L5ToDate - AsofDate;
        }
        L1Days := L1ToDate - AsofDate;
        L2Days := L2ToDate - L1ToDate;
        L3Days := L3ToDate - L2ToDate;
        L4Days := L4ToDate - L3ToDate;
        L5Days := L5ToDate - AsofDate;
        
        L1DaysCaption := '0 - ' + FORMAT(ABS(L1Days));
        L2DaysCaption := FORMAT(ABS(L1Days) + 1) + ' - ' + FORMAT(ABS(L2Days) - 1);
        L3DaysCaption := FORMAT(ABS(L2Days)) + ' - ' + FORMAT(ABS(L3Days) - 1);
        L4DaysCaption := FORMAT(ABS(L3Days)) + ' - ' + FORMAT(ABS(L4Days) - 1);
        L5DaysCaption := 'Above ' + FORMAT(ABS(L4Days));
        */
    //210916
    end;
    var ItemApplEntry: Record "Item Application Entry";
    Item: Record Item;
    TempExcelBuffer: Record "Excel Buffer" temporary;
    ItemCategory: Record "Item Category";
    L1Label: Text[30];
    L2Label: Text[30];
    L3Label: Text[30];
    L4Label: Text[30];
    L5Label: Text[30];
    ClosingStockLabel: Text[30];
    LEVELI: DateFormula;
    LEVELII: DateFormula;
    LEVELIII: DateFormula;
    LEVELIV: DateFormula;
    LEVELV: DateFormula;
    AsofDate: Date;
    L1FromDate: Date;
    L1ToDate: Date;
    L2FromDate: Date;
    L2ToDate: Date;
    L3FromDate: Date;
    L3ToDate: Date;
    L4FromDate: Date;
    L4ToDate: Date;
    L5FromDate: Date;
    L5ToDate: Date;
    L6FromDate: Date;
    ExporttoExcel: Boolean;
    PrintSummary: Boolean;
    L1Days: Integer;
    L2Days: Integer;
    L3Days: Integer;
    L4Days: Integer;
    L5Days: Integer;
    Row: Integer;
    Column: Integer;
    ItemRetailPrice: Decimal;
    L1Qty: Decimal;
    L2Qty: Decimal;
    L3Qty: Decimal;
    L4Qty: Decimal;
    L5Qty: Decimal;
    NegativeSales: Decimal;
    ClosingStock: Decimal;
    L1Val: Decimal;
    L2Val: Decimal;
    L3Val: Decimal;
    L4Val: Decimal;
    L5Val: Decimal;
    ClosingStockValue: Decimal;
    ICL1Qty: Decimal;
    ICL2Qty: Decimal;
    ICL3Qty: Decimal;
    ICL4Qty: Decimal;
    ICL5Qty: Decimal;
    ICNegativeSales: Decimal;
    ICClosingStock: Decimal;
    ICL1Val: Decimal;
    ICL2Val: Decimal;
    ICL3Val: Decimal;
    ICL4Val: Decimal;
    ICL5Val: Decimal;
    ICClosingStockValue: Decimal;
    PGL1Qty: Decimal;
    PGL2Qty: Decimal;
    PGL3Qty: Decimal;
    PGL4Qty: Decimal;
    PGL5Qty: Decimal;
    PGNegativeSales: Decimal;
    PGClosingStock: Decimal;
    PGL1Val: Decimal;
    PGL2Val: Decimal;
    PGL3Val: Decimal;
    PGL4Val: Decimal;
    PGL5Val: Decimal;
    PGClosingStockValue: Decimal;
    NetL1Qty: Decimal;
    NetL2Qty: Decimal;
    NetL3Qty: Decimal;
    NetL4Qty: Decimal;
    NetL5Qty: Decimal;
    NetNegativeSales: Decimal;
    NetClosingStock: Decimal;
    NetL1Val: Decimal;
    NetL2Val: Decimal;
    NetL3Val: Decimal;
    NetL4Val: Decimal;
    NetL5Val: Decimal;
    NetClosingStockValue: Decimal;
    NegativeSalesValue: Decimal;
    ICNegativeSalesValue: Decimal;
    PGNegativeSalesValue: Decimal;
    NetNegativeSalesValue: Decimal;
    L3NegativeSalesValue: Decimal;
    L4NegativeSalesValue: Decimal;
    Itemvar: Code[20];
    L1DaysCaption: Text;
    L2DaysCaption: Text;
    L3DaysCaption: Text;
    L4DaysCaption: Text;
    L5DaysCaption: Text;
    AppQty: Decimal;
    L1ValTot: Decimal;
    L2ValTot: Decimal;
    L3ValTot: Decimal;
    L4ValTot: Decimal;
    L5ValTot: Decimal;
    L1QtyTot: Decimal;
    L2QtyTot: Decimal;
    L3QtyTot: Decimal;
    L4QtyTot: Decimal;
    L5QtyTot: Decimal;
    PurchRcptLine: Record "Purch. Rcpt. Line";
    MrnDate: Date;
    SalesShipmentLine: Record "Sales Shipment Line";
    ShipDate: Date;
    ILE: Record "Item Ledger Entry";
    ILEENT: Integer;
    ItemApp2: Record "Item Application Entry";
    ItemAgingUpdate: Report "Gss Item Aging Update";
    procedure CalculateDates()
    begin
        if L1FromDate = 0D then L1FromDate:=AsofDate;
        L1FromDate:=AsofDate;
        L1ToDate:=CalcDate(LEVELI, AsofDate + 1);
        L2FromDate:=L1ToDate - 1;
        L2ToDate:=CalcDate(LEVELII, L2FromDate) + 1;
        L3FromDate:=L2ToDate - 1;
        L3ToDate:=CalcDate(LEVELIII, L3FromDate) + 1;
        L4FromDate:=L3ToDate - 1;
        L4ToDate:=CalcDate(LEVELIV, L4FromDate) + 1;
        L5FromDate:=L4ToDate - 1;
        L5ToDate:=CalcDate(LEVELV, L5FromDate) + 1;
        L6FromDate:=L5ToDate;
        L1Days:=(L1ToDate - AsofDate) - 1;
        L2Days:=(L2ToDate - L1ToDate);
        L3Days:=(L3ToDate - L2ToDate);
        L4Days:=(L4ToDate - L3ToDate);
        L5Days:=(L5ToDate - AsofDate) - 1;
        L1DaysCaption:='0 - ' + Format(Abs(L1Days));
        L2DaysCaption:=Format(Abs(L1Days) + 1) + ' - ' + Format(Abs(L1Days) + Abs(L2Days));
        L3DaysCaption:=Format(Abs(L1Days) + Abs(L2Days) + 1) + ' - ' + Format(Abs(L1Days) + Abs(L2Days) + Abs(L3Days));
        L4DaysCaption:=Format(Abs(L1Days) + Abs(L2Days) + Abs(L3Days) + 1) + ' - ' + Format(Abs(L1Days) + Abs(L2Days) + Abs(L3Days) + Abs(L4Days));
        L5DaysCaption:='Above ' + Format(Abs(L1Days) + Abs(L2Days) + Abs(L3Days) + Abs(L4Days));
        L1Label:=Format(L1FromDate, 0, '<Day>.<Month Text,3>.<year>') + ' to ' + Format(L1ToDate, 0, '<Day>.<Month Text,3>.<year>');
        L2Label:=Format(L2FromDate, 0, '<Day>.<Month Text,3>.<year>') + ' to ' + Format(L2ToDate, 0, '<Day>.<Month Text,3>.<year>');
        L3Label:=Format(L3FromDate, 0, '<Day>.<Month Text,3>.<year>') + ' to ' + Format(L3ToDate, 0, '<Day>.<Month Text,3>.<year>');
        L4Label:=Format(L4FromDate, 0, '<Day>.<Month Text,3>.<year>') + ' to ' + Format(L4ToDate, 0, '<Day>.<Month Text,3>.<year>');
        L5Label:='Before ' + Format(L5FromDate, 0, '<Day>.<Month Text,3>.<year>');
    end;
    procedure CalculateDatesOld()
    begin
        //Ansar-0179 -
        L1FromDate:=AsofDate;
        L1ToDate:=CalcDate(LEVELI, AsofDate + 1);
        L2FromDate:=L1ToDate - 1;
        L2ToDate:=CalcDate(LEVELII, L2FromDate);
        L3FromDate:=L2ToDate - 1;
        L3ToDate:=CalcDate(LEVELIII, L3FromDate);
        L4FromDate:=L3ToDate - 1;
        L4ToDate:=CalcDate(LEVELIV, L4FromDate);
        L5FromDate:=L4ToDate - 1;
        L5ToDate:=CalcDate(LEVELV, L5FromDate);
        L6FromDate:=L5ToDate;
        L1Label:=Format(L1FromDate - L1FromDate + 1) + '-' + Format(L1FromDate - L1ToDate + 1) + ' Days';
        L2Label:=Format(L1FromDate - L1ToDate + 2) + '-' + Format(L1FromDate - L2ToDate + 1) + ' Days';
        L3Label:=Format(L1FromDate - L2ToDate + 2) + '-' + Format(L1FromDate - L3ToDate + 1) + ' Days';
        L4Label:=Format(L1FromDate - L3ToDate + 2) + '-' + Format(L1FromDate - L4ToDate + 1) + ' Days';
        L5Label:=Format(L1FromDate - L4ToDate + 2) + '-' + Format(L1FromDate - L5ToDate + 1) + ' Days';
        L1DaysCaption:='0 - ' + Format(Abs(L1Days));
        L2DaysCaption:=Format(Abs(L1Days) + 1) + ' - ' + Format(Abs(L2Days) - 1);
        L3DaysCaption:=Format(Abs(L2Days)) + ' - ' + Format(Abs(L3Days) - 1);
        L4DaysCaption:=Format(Abs(L3Days)) + ' - ' + Format(Abs(L4Days) - 1);
        L5DaysCaption:='Above ' + Format(Abs(L4Days));
    //Ansar-0179 +
    end;
}
