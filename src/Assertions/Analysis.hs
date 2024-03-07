module Assertions.Analysis where

import Utils.Maps
import RL.Values
import Inversion.Inverter

import Assertions.Abstraction

type AStore = Map Name AValue
type State = Map Label (AStore, AStore)

-- Workqueue
-- initial stores: entry start = input = any, non-input = nil
--                 exit end = output = any, non-output = nil
--                 all others: everything bottom
-- if anything changes in output, work on children
-- work through list of blocks to analyse
-- swap around and check if things change? if so, repeat

-- analyse a block:
-- Startstore = (lub NONEAWARE) of parents endstore (and glb? current start)
-- fold over the steps for new endstore
-- lub with old endstore

-- after fixpoint reached: remove assertions when trivial
--                         blocks when trivial false assert / none