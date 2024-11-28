// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VSubClauseEvaluator.h for the primary calling header

#include "VSubClauseEvaluator.h"
#include "VSubClauseEvaluator__Syms.h"

//==========
CData/*2:0*/ VSubClauseEvaluator::__Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[32];
CData/*0:0*/ VSubClauseEvaluator::__Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[32];

VL_CTOR_IMP(VSubClauseEvaluator) {
    VSubClauseEvaluator__Syms* __restrict vlSymsp = __VlSymsp = new VSubClauseEvaluator__Syms(this, name());
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void VSubClauseEvaluator::__Vconfigure(VSubClauseEvaluator__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-12);
    Verilated::timeprecision(-12);
}

VSubClauseEvaluator::~VSubClauseEvaluator() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = NULL);
}

void VSubClauseEvaluator::_eval_initial(VSubClauseEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSubClauseEvaluator::_eval_initial\n"); );
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void VSubClauseEvaluator::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSubClauseEvaluator::final\n"); );
    // Variables
    VSubClauseEvaluator__Syms* __restrict vlSymsp = this->__VlSymsp;
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void VSubClauseEvaluator::_eval_settle(VSubClauseEvaluator__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSubClauseEvaluator::_eval_settle\n"); );
    VSubClauseEvaluator* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__1(vlSymsp);
    vlTOPp->__Vm_traceActivity[1U] = 1U;
    vlTOPp->__Vm_traceActivity[0U] = 1U;
}

void VSubClauseEvaluator::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSubClauseEvaluator::_ctor_var_reset\n"); );
    // Body
    clause_mask = VL_RAND_RESET_I(5);
    unassign = VL_RAND_RESET_I(5);
    assignment = VL_RAND_RESET_I(5);
    clause_pole = VL_RAND_RESET_I(5);
    var1 = VL_RAND_RESET_I(9);
    var2 = VL_RAND_RESET_I(9);
    var3 = VL_RAND_RESET_I(9);
    var4 = VL_RAND_RESET_I(9);
    var5 = VL_RAND_RESET_I(9);
    unit_clause = VL_RAND_RESET_I(1);
    implied_variable = VL_RAND_RESET_I(9);
    new_assignment = VL_RAND_RESET_I(1);
    { int __Vi0=0; for (; __Vi0<5; ++__Vi0) {
            SubClauseEvaluator__DOT__var_indices[__Vi0] = VL_RAND_RESET_I(9);
    }}
    SubClauseEvaluator__DOT__partial_sat_eval__DOT__eval_result = VL_RAND_RESET_I(5);
    SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position = VL_RAND_RESET_I(3);
    SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit = VL_RAND_RESET_I(1);
    __Vtableidx1 = 0;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[0] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[1] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[2] = 1U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[3] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[4] = 2U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[5] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[6] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[7] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[8] = 3U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[9] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[10] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[11] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[12] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[13] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[14] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[15] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[16] = 4U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[17] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[18] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[19] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[20] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[21] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[22] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[23] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[24] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[25] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[26] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[27] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[28] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[29] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[30] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__encoded_position[31] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[0] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[1] = 1U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[2] = 1U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[3] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[4] = 1U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[5] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[6] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[7] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[8] = 1U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[9] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[10] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[11] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[12] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[13] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[14] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[15] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[16] = 1U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[17] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[18] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[19] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[20] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[21] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[22] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[23] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[24] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[25] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[26] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[27] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[28] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[29] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[30] = 0U;
    __Vtable1_SubClauseEvaluator__DOT__unit_clause_eval__DOT__valid_unit[31] = 0U;
    { int __Vi0=0; for (; __Vi0<2; ++__Vi0) {
            __Vm_traceActivity[__Vi0] = VL_RAND_RESET_I(1);
    }}
}
