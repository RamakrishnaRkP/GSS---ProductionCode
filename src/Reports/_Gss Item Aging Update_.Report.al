report 60111 "Gss Item Aging Update"
{
    ProcessingOnly = true;
    Caption = 'Item Aging Update';
    Permissions = tabledata "Item Application Entry"=m;

    dataset
    {
        dataitem(ItemApplicationEntry; "Item Application Entry")
        {
            DataItemTableView = SORTING("GSSPurchase Date")WHERE("GSSPurchase Date"=FILTER(''));
            RequestFilterFields = "Entry No.", "Item Ledger Entry No.";

            trigger OnPreDataItem()
            begin
                Dlg.Open('IAE Entry No. -#1#########');
            end;
            trigger OnAfterGetRecord()
            begin
                Dlg.UPDATE(1, "Entry No.");
                CLEAR(IAE);
                IAE.GET("Entry No.");
                CLEAR(ILE);
                ILE.GET(IAE."Item Ledger Entry No.");
                IF ILE."Entry Type" = ILE."Entry Type"::Purchase THEN BEGIN
                    IF ILE.Quantity > 0 THEN BEGIN
                        IAE."GSSPurchase Date":=ILE."Posting Date";
                        IAE.MODIFY;
                    END
                    ELSE
                    BEGIN
                        CLEAR(InbIAE);
                        InbIAE.RESET;
                        InbIAE.SETCURRENTKEY("Item Ledger Entry No.");
                        InbIAE.SETRANGE("Item Ledger Entry No.", IAE."Inbound Item Entry No.");
                        IF InbIAE.FINDFIRST THEN BEGIN
                            IF InbIAE."GSSPurchase Date" <> 0D THEN BEGIN
                                IAE."GSSPurchase Date":=InbIAE."GSSPurchase Date";
                                IAE.MODIFY;
                            END;
                        END;
                    END;
                END;
                IF ILE."Entry Type" = ILE."Entry Type"::Sale THEN BEGIN
                    IF ILE.Quantity > 0 THEN BEGIN
                        IAE."GSSPurchase Date":=ILE."Posting Date";
                        IAE.MODIFY;
                    END
                    ELSE
                    BEGIN
                        CLEAR(InbIAE);
                        InbIAE.RESET;
                        InbIAE.SETCURRENTKEY("Item Ledger Entry No.");
                        InbIAE.SETRANGE("Item Ledger Entry No.", IAE."Inbound Item Entry No.");
                        IF InbIAE.FINDFIRST THEN BEGIN
                            IF InbIAE."GSSPurchase Date" <> 0D THEN BEGIN
                                IAE."GSSPurchase Date":=InbIAE."GSSPurchase Date";
                                IAE.MODIFY;
                            END;
                        END;
                    END;
                END;
                IF ILE."Entry Type" = ILE."Entry Type"::"Positive Adjmt." THEN BEGIN
                    IF ILE.Quantity > 0 THEN BEGIN
                        IAE."GSSPurchase Date":=ILE."Posting Date";
                        IAE.MODIFY;
                    END
                    ELSE
                    BEGIN
                        CLEAR(InbIAE);
                        InbIAE.RESET;
                        InbIAE.SETCURRENTKEY("Item Ledger Entry No.");
                        InbIAE.SETRANGE("Item Ledger Entry No.", IAE."Inbound Item Entry No.");
                        IF InbIAE.FINDFIRST THEN BEGIN
                            IF InbIAE."GSSPurchase Date" <> 0D THEN BEGIN
                                IAE."GSSPurchase Date":=InbIAE."GSSPurchase Date";
                                IAE.MODIFY;
                            END;
                        END;
                    END;
                END;
                IF ILE."Entry Type" = ILE."Entry Type"::"Negative Adjmt." THEN BEGIN
                    IF ILE.Quantity > 0 THEN BEGIN
                        IAE."GSSPurchase Date":=ILE."Posting Date";
                        IAE.MODIFY;
                    END
                    ELSE
                    BEGIN
                        CLEAR(InbIAE);
                        InbIAE.RESET;
                        InbIAE.SETCURRENTKEY("Item Ledger Entry No.");
                        InbIAE.SETRANGE("Item Ledger Entry No.", IAE."Inbound Item Entry No.");
                        IF InbIAE.FINDFIRST THEN BEGIN
                            IF InbIAE."GSSPurchase Date" <> 0D THEN BEGIN
                                IAE."GSSPurchase Date":=InbIAE."GSSPurchase Date";
                                IAE.MODIFY;
                            END;
                        END;
                    END;
                END;
                IF ILE."Entry Type" = ILE."Entry Type"::Transfer THEN BEGIN
                    IF ILE.Quantity > 0 THEN BEGIN
                        CLEAR(OutbIAE);
                        OutbIAE.RESET;
                        OutbIAE.SETCURRENTKEY("Item Ledger Entry No.");
                        OutbIAE.SETRANGE(OutbIAE."Item Ledger Entry No.", IAE."Outbound Item Entry No.");
                        IF OutbIAE.FINDFIRST THEN BEGIN
                            IF OutbIAE."GSSPurchase Date" <> 0D THEN BEGIN
                                IAE."GSSPurchase Date":=OutbIAE."GSSPurchase Date";
                                IAE.MODIFY;
                            END;
                        END;
                    END
                    ELSE
                    BEGIN
                        CLEAR(InbIAE);
                        InbIAE.RESET;
                        InbIAE.SETCURRENTKEY("Item Ledger Entry No.");
                        InbIAE.SETRANGE("Item Ledger Entry No.", IAE."Inbound Item Entry No.");
                        IF InbIAE.FINDFIRST THEN BEGIN
                            IF InbIAE."GSSPurchase Date" <> 0D THEN BEGIN
                                IAE."GSSPurchase Date":=InbIAE."GSSPurchase Date";
                                IAE.MODIFY;
                            END;
                        END;
                    END;
                END;
            end;
            trigger ONPostDataItem()
            begin
                Dlg.CLOSE;
                MESSAGE('Updated Successfully!');
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var ILE: Record "Item Ledger Entry";
    IAE: Record "Item Application Entry";
    ILE2: Record "Item Ledger Entry";
    InbIAE: Record "Item Application Entry";
    OutbIAE: Record "Item Application Entry";
    Dlg: Dialog;
}
