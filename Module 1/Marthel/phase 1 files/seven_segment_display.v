 7'b0000010; // 6: a c d e f g on
            4'h7: seg = 7'b1111000; // 7: a b c on
            4'h8: seg = 7'b0000000; // 8: a b c d e f g on
            4'h9: seg = 7'b0010000; // 9: a b c d f g on
            4'hA: seg = 7'b0001000; // A: a b c e f g on
            4'hB: seg = 7'b0000011; // b: c d e f g on (lowercase b, or treat as 11)
            4'hC: seg = 7'b1000110; // C: a d e f on
            4'hD: seg = 7'b0100001; // d: b c d e g on (lowercase d)
            4'hE: seg = 7'b0000110; // E: a d e f g on
            4'hF: seg = 7'b0001110; // F: a e f g on
            default: seg = 7'b1111111; // Blank for undefined values
        endcase
    end

endmodule
