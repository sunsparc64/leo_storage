%%====================================================================
%%
%% LeoFS Storage
%%
%% Copyright (c) 2012-2014 Rakuten, Inc.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------
%% LeoFS Storage - Constant/Macro/Record
%%
%%====================================================================
-author('Yosuke Hara').

%% @doc default-values.
%%
-define(SHUTDOWN_WAITING_TIME, 2000).
-define(MAX_RESTART,              5).
-define(MAX_TIME,                60).

-ifdef(TEST).
-define(TIMEOUT,         1000).
-define(DEF_REQ_TIMEOUT, 1000).
-else.
-define(TIMEOUT,          5000). %%  5sec
-define(DEF_REQ_TIMEOUT, 30000). %% 30sec
-endif.

%% @doc operationg-methods.
%%
-define(CMD_GET,    get).
-define(CMD_PUT,    put).
-define(CMD_DELETE, delete).
-define(CMD_HEAD,   head).
-type(request_verb() :: ?CMD_GET |
                        ?CMD_PUT |
                        ?CMD_DELETE |
                        ?CMD_HEAD
                        ).

%% @doc queue-related.
%%
-define(QUEUE_ID_PER_OBJECT,        'leo_per_object_queue').
-define(QUEUE_ID_SYNC_BY_VNODE_ID,  'leo_sync_by_vnode_id_queue').
-define(QUEUE_ID_DIRECTORY,         'leo_directory_queue').
-define(QUEUE_ID_REBALANCE,         'leo_rebalance_queue').
-define(QUEUE_ID_ASYNC_DELETION,    'leo_async_deletion_queue').
-define(QUEUE_ID_RECOVERY_NODE,     'leo_recovery_node_queue').
-define(QUEUE_ID_SYNC_OBJ_WITH_DC,  'leo_sync_obj_with_dc_queue').
-define(QUEUE_ID_COMP_META_WITH_DC, 'leo_comp_meta_with_dc_queue').
-define(QUEUE_ID_DEL_DIR,           'leo_delete_dir_queue').

-define(QUEUE_TYPE_PER_OBJECT,        'queue_type_per_object').
-define(QUEUE_TYPE_SYNC_BY_VNODE_ID,  'queue_type_sync_by_vnode_id').
-define(QUEUE_TYPE_REBALANCE,         'queue_type_rebalance').
-define(QUEUE_TYPE_ASYNC_DELETION,    'queue_type_async_deletion').
-define(QUEUE_TYPE_RECOVERY_NODE,     'queue_type_recovery_node').
-define(QUEUE_TYPE_SYNC_OBJ_WITH_DC,  'queue_type_sync_obj_with_dc').
-define(QUEUE_TYPE_COMP_META_WITH_DC, 'queue_type_comp_meta_with_dc').
-define(QUEUE_TYPE_DEL_DIR,           'queue_type_delete_dir').

-define(ERR_TYPE_REPLICATE_DATA,      'error_msg_replicate_data').
-define(ERR_TYPE_RECOVER_DATA,        'error_msg_recover_data').
-define(ERR_TYPE_DELETE_DATA,         'error_msg_delete_data').
-define(ERR_TYPE_REPLICATE_INDEX,     'error_msg_replicate_index').
-define(ERR_TYPE_RECOVER_INDEX,       'error_msg_recover_index').
-define(ERR_TYPE_DELETE_INDEX,        'error_msg_delete_index').

-define(TBL_REBALANCE_COUNTER,        'leo_rebalance_counter').

%% @doc error messages.
%%
-define(ERROR_COULD_NOT_GET_DATA,       "Could not get data").
-define(ERROR_COULD_NOT_GET_META,       "Could not get a metadata").
-define(ERROR_COULD_NOT_GET_SYSTEM_CONF,"Could not get the system configuration").
-define(ERROR_RECOVER_FAILURE,          "Recover failure").
-define(ERROR_REPLICATE_FAILURE,        "Replicate failure").
-define(ERROR_COULD_NOT_GET_REDUNDANCY, "Could not get redundancy").
-define(ERROR_COULD_NOT_CONNECT,        "Could not connect").
-define(ERROR_COULD_MATCH,              "Could not match").
-define(ERROR_COULD_SEND_OBJ,           "Could not send an object to a remote cluster").


%% @doc request parameter for READ
%%
-record(read_parameter, {
          ref           :: reference(),
          addr_id       :: integer(),
          key           :: binary(),
          etag = 0      :: integer(),
          start_pos = 0 :: integer(),
          end_pos   = 0 :: integer(),
          quorum        :: integer(),
          req_id        :: integer()
         }).

%% @doc Queue's Message.
%%
-record(inconsistent_data_message, {
          id = 0                :: integer(),
          type                  :: atom(),
          addr_id = 0           :: integer(),
          key                   :: any(),
          meta                  :: tuple(),
          timestamp = 0         :: integer(),
          times = 0             :: integer()}).

-record(inconsistent_index_message, {
          id = 0                :: integer(),
          type                  :: atom(),
          addr_id = 0           :: integer(),
          key                   :: any(),
          timestamp = 0         :: integer(),
          times = 0             :: integer()}).

-record(sync_unit_of_vnode_message, {
          id = 0                :: integer(),
          vnode_id = 0          :: integer(),
          node                  :: atom(),
          timestamp = 0         :: integer(),
          times = 0             :: integer()
         }).

-record(rebalance_message, {
          id = 0                :: integer(),
          vnode_id = 0          :: integer(),
          addr_id = 0           :: integer(),
          key                   :: binary(),
          node                  :: atom(),
          timestamp = 0         :: integer(),
          times = 0             :: integer()
         }).

-record(async_deletion_message, {
          id = 0                :: integer(),
          addr_id = 0           :: integer(),
          key                   :: any(),
          timestamp = 0         :: integer(),
          times = 0             :: integer()}).

-record(recovery_node_message, {
          id = 0                :: integer(),
          node                  :: atom(),
          timestamp = 0         :: integer(),
          times = 0             :: integer()}).

-record(inconsistent_data_with_dc, {
          id = 0                :: integer(),
          cluster_id            :: atom(),
          addr_id = 0           :: integer(),
          key                   :: binary(),
          del = 0               :: integer(), %% del:[0:false, 1:true]
          timestamp = 0         :: integer(),
          times = 0             :: integer()}).

-record(comparison_metadata_with_dc, {
          id = 0                 :: integer(),
          cluster_id             :: atom(),
          list_of_addrid_and_key :: list(),
          timestamp = 0          :: integer()
         }).

-record(delete_dir, {
          id = 0        :: integer(),
          node          :: atom(),
          keys = []     :: [binary()|undefined],
          timestamp = 0 :: integer()
         }).



%% @doc macros.
%%
-define(env_storage_device(),
        case application:get_env(leo_storage, obj_containers) of
            {ok, EnvStorageDevice} ->
                EnvStorageDevice;
            _ ->
                []
        end).

-define(env_num_of_replicators(),
        case application:get_env(leo_storage, num_of_replicators) of
            {ok, NumOfReplicators} -> NumOfReplicators;
            _ -> 8
        end).

-define(env_num_of_repairers(),
        case application:get_env(leo_storage, num_of_repairers) of
            {ok, NumOfRepairers} -> NumOfRepairers;
            _ -> 8
        end).

-define(env_num_of_mq_procs(),
        case application:get_env(leo_storage, num_of_mq_procs) of
            {ok, NumOfMQProcs} -> NumOfMQProcs;
            _ -> 3
        end).

-define(env_size_of_stacked_objs(),
        case application:get_env(leo_storage, size_of_stacked_objs) of
            {ok, SizeOfStackedObjs} -> SizeOfStackedObjs;
            _ -> (1024 * 1024) %% 1MB
        end).

-define(env_stacking_timeout(),
        case application:get_env(leo_storage, stacking_timeout) of
            {ok, StackingTimeout} -> timer:seconds(StackingTimeout);
            _ -> 1000 %% 1sec
        end).

-define(env_grp_level_1(),
        case application:get_env(leo_storage, grp_level_1) of
            {ok, _GrpLevel1} -> _GrpLevel1;
            _ -> []
        end).

-define(env_grp_level_2(),
        case application:get_env(leo_storage, grp_level_2) of
            {ok, _GrpLevel2} -> _GrpLevel2;
            _ -> []
        end).

-define(env_num_of_vnodes(),
        case application:get_env(leo_storage, num_of_vnodes) of
            {ok, _NumOfVNodes} -> _NumOfVNodes;
            _ -> 168
        end).


-define(DEF_WATCH_INTERVAL,   5000).
-define(DEF_MEM_CAPACITY, 33554432).
-define(DEF_CPU_LOAD_AVG, 100.0).
-define(DEF_CPU_UTIL,      90.0).
-define(DEF_INPUT_FOR_INTERVAL,  134217728). %% 128MB
-define(DEF_OUTPUT_FOR_INTERVAL, 134217728). %% 128MB
-define(DEF_DISK_UTIL,      90.0).

%% -define(DEF_MEM_CAPACITY, 500000000).

-define(env_watchdog_check_interval(),
        case application:get_env(leo_storage, watchdog_check_interval) of
            {ok, EnvWDCheckInterval} ->
                EnvWDCheckInterval;
            _ ->
                ?DEF_WATCH_INTERVAL
        end).

-define(env_watchdog_rex_enabled(),
        case application:get_env(leo_storage, watchdog_rex_enabled) of
            {ok, EnvWDRexEnabled} ->
                EnvWDRexEnabled;
            _ ->
                true
        end).
-define(env_watchdog_max_mem_capacity(),
        case application:get_env(leo_storage, watchdog_max_mem_capacity) of
            {ok, EnvWDMaxMemCapacity} ->
                EnvWDMaxMemCapacity;
            _ ->
                ?DEF_MEM_CAPACITY
        end).


-define(env_watchdog_cpu_enabled(),
        case application:get_env(leo_storage, watchdog_cpu_enabled) of
            {ok, EnvWDCpuEnabled} ->
                EnvWDCpuEnabled;
            _ ->
                true
        end).
-define(env_watchdog_max_cpu_load_avg(),
        case application:get_env(leo_storage, watchdog_max_cpu_load_avg) of
            {ok, EnvWDMaxCpuLoadAvg} ->
                EnvWDMaxCpuLoadAvg;
            _ ->
                ?DEF_CPU_LOAD_AVG
        end).
-define(env_watchdog_max_cpu_util(),
        case application:get_env(leo_storage, watchdog_max_cpu_util) of
            {ok, EnvWDMaxCpuUtil} ->
                EnvWDMaxCpuUtil;
            _ ->
                ?DEF_CPU_UTIL
        end).


-define(env_watchdog_io_enabled(),
        case application:get_env(leo_storage, watchdog_io_enabled) of
            {ok, EnvWDIOEnabled} ->
                EnvWDIOEnabled;
            _ ->
                true
        end).
-define(env_watchdog_max_input_for_interval(),
        case application:get_env(leo_storage, watchdog_max_input_for_interval) of
            {ok, EnvWDMaxInputForInterval} ->
                EnvWDMaxInputForInterval;
            _ ->
                ?DEF_INPUT_FOR_INTERVAL
        end).
-define(env_watchdog_max_output_for_interval(),
        case application:get_env(leo_storage, watchdog_max_output_for_interval) of
            {ok, EnvWDMaxOutputForInterval} ->
                EnvWDMaxOutputForInterval;
            _ ->
                ?DEF_OUTPUT_FOR_INTERVAL
        end).
-define(env_watchdog_max_disk_util(),
        case application:get_env(leo_storage, watchdog_max_disk_util) of
            {ok, EnvWDMaxDiskUtil} ->
                EnvWDMaxDiskUtil;
            _ ->
                ?DEF_DISK_UTIL
        end).



-define(DEF_MQ_NUM_OF_BATCH_PROC, 1).
-define(DEF_MQ_INTERVAL_MAX, 32).
-define(DEF_MQ_INTERVAL_MIN,  8).

-define(PROP_MQ_PER_OBJ_1,   cns_num_of_batch_process_per_object).
-define(PROP_MQ_PER_OBJ_2,   cns_interval_per_object_max).
-define(PROP_MQ_PER_OBJ_3,   cns_interval_per_object_min).
-define(PROP_MQ_SYNC_VN_1,   cns_num_of_batch_process_sync_by_vnode_id).
-define(PROP_MQ_SYNC_VN_2,   cns_interval_sync_by_vnode_id_max).
-define(PROP_MQ_SYNC_VN_3,   cns_interval_sync_by_vnode_id_min).
-define(PROP_MQ_REBALANCE_1, cns_num_of_batch_process_rebalance).
-define(PROP_MQ_REBALANCE_2, cns_interval_rebalance_max).
-define(PROP_MQ_REBALANCE_3, cns_interval_rebalance_min).
-define(PROP_MQ_DELETE_1,    cns_num_of_batch_process_async_deletion).
-define(PROP_MQ_DELETE_2,    cns_interval_async_deletion_max).
-define(PROP_MQ_DELETE_3,    cns_interval_async_deletion_min).
-define(PROP_MQ_RECOVERY_1,  cns_num_of_batch_process_recovery_node).
-define(PROP_MQ_RECOVERY_2,  cns_interval_recovery_node_max).
-define(PROP_MQ_RECOVERY_3,  cns_interval_recovery_node_min).
-define(PROP_MQ_SYNC_DC_1,   cns_num_of_batch_process_sync_obj_with_dc).
-define(PROP_MQ_SYNC_DC_2,   cns_interval_sync_obj_with_dc_max).
-define(PROP_MQ_SYNC_DC_3,   cns_interval_sync_obj_with_dc_min).
-define(PROP_MQ_COMP_DC_1,   cns_num_of_batch_process_comp_meta_with_dc).
-define(PROP_MQ_COMP_DC_2,   cns_interval_comp_meta_with_dc_max).
-define(PROP_MQ_COMP_DC_3,   cns_interval_comp_meta_with_dc_min).
-define(PROP_MQ_DEL_DIR_1,   cns_num_of_batch_process_del_dir).
-define(PROP_MQ_DEL_DIR_2,   cns_interval_del_dir_max).
-define(PROP_MQ_DEL_DIR_3,   cns_interval_del_dir_min).

-define(env_mq_consumption_intervals(),
        [
         %% per_object
         {?PROP_MQ_PER_OBJ_1,
          case application:get_env(leo_storage, ?PROP_MQ_PER_OBJ_1) of
              {ok, _CnsNumofBatchProc1} -> _CnsNumofBatchProc1;
              _ -> ?DEF_MQ_NUM_OF_BATCH_PROC
          end},
         {?PROP_MQ_PER_OBJ_2,
          case application:get_env(leo_storage, ?PROP_MQ_PER_OBJ_2) of
              {ok, _CnsInterval1_Min} -> _CnsInterval1_Min;
              _ -> ?DEF_MQ_INTERVAL_MIN
          end},
         {?PROP_MQ_PER_OBJ_3,
          case application:get_env(leo_storage, ?PROP_MQ_PER_OBJ_3) of
              {ok, _CnsInterval1_Max} -> _CnsInterval1_Max;
              _ -> ?DEF_MQ_INTERVAL_MAX
          end},
         %% sync_by_vnode_id
         {?PROP_MQ_SYNC_VN_1,
          case application:get_env(leo_storage, ?PROP_MQ_SYNC_VN_1) of
              {ok, _CnsNumofBatchProc2} -> _CnsNumofBatchProc2;
              _ -> ?DEF_MQ_NUM_OF_BATCH_PROC
          end},
         {?PROP_MQ_SYNC_VN_2,
          case application:get_env(leo_storage, ?PROP_MQ_SYNC_VN_2) of
              {ok, _CnsInterval2_Min} -> _CnsInterval2_Min;
              _ -> ?DEF_MQ_INTERVAL_MIN
          end},
         {?PROP_MQ_SYNC_VN_3,
          case application:get_env(leo_storage, ?PROP_MQ_SYNC_VN_3) of
              {ok, _CnsInterval2_Max} -> _CnsInterval2_Max;
              _ -> ?DEF_MQ_INTERVAL_MAX
          end},
         %% for rebalance
         {?PROP_MQ_REBALANCE_1,
          case application:get_env(leo_storage, ?PROP_MQ_REBALANCE_1) of
              {ok, _CnsNumofBatchProc3} -> _CnsNumofBatchProc3;
              _ -> ?DEF_MQ_NUM_OF_BATCH_PROC
          end},
         {?PROP_MQ_REBALANCE_2,
          case application:get_env(leo_storage, ?PROP_MQ_REBALANCE_2) of
              {ok, _CnsInterval3_Min} -> _CnsInterval3_Min;
              _ -> ?DEF_MQ_INTERVAL_MIN
          end},
         {?PROP_MQ_REBALANCE_3,
          case application:get_env(leo_storage, ?PROP_MQ_REBALANCE_3) of
              {ok, _CnsInterval3_Max} -> _CnsInterval3_Max;
              _ -> ?DEF_MQ_INTERVAL_MAX
          end},
         %% async deletion objects (after remove a bucket)
         {?PROP_MQ_DELETE_1,
          case application:get_env(leo_storage, ?PROP_MQ_DELETE_1) of
              {ok, _CnsNumofBatchProc4} -> _CnsNumofBatchProc4;
              _ -> ?DEF_MQ_NUM_OF_BATCH_PROC
          end},
         {?PROP_MQ_DELETE_2,
          case application:get_env(leo_storage, ?PROP_MQ_DELETE_2) of
              {ok, _CnsInterval3_Min} -> _CnsInterval3_Min;
              _ -> ?DEF_MQ_INTERVAL_MIN
          end},
         {?PROP_MQ_DELETE_3,
          case application:get_env(leo_storage, ?PROP_MQ_DELETE_3) of
              {ok, _CnsInterval3_Max} -> _CnsInterval3_Max;
              _ -> ?DEF_MQ_INTERVAL_MAX
          end},
         %% recovery node
         {?PROP_MQ_RECOVERY_1,
          case application:get_env(leo_storage, ?PROP_MQ_RECOVERY_1) of
              {ok, _CnsNumofBatchProc5} -> _CnsNumofBatchProc5;
              _ -> ?DEF_MQ_NUM_OF_BATCH_PROC
          end},
         {?PROP_MQ_RECOVERY_2,
          case application:get_env(leo_storage, ?PROP_MQ_RECOVERY_2) of
              {ok, _CnsInterval4_Min} -> _CnsInterval4_Min;
              _ -> ?DEF_MQ_INTERVAL_MIN
          end},
         {?PROP_MQ_RECOVERY_3,
          case application:get_env(leo_storage, ?PROP_MQ_RECOVERY_3) of
              {ok, _CnsInterval4_Max} -> _CnsInterval4_Max;
              _ -> ?DEF_MQ_INTERVAL_MAX
          end},
         %% sync obj with dc
         {?PROP_MQ_SYNC_DC_1,
          case application:get_env(leo_storage, ?PROP_MQ_SYNC_DC_1) of
              {ok, _CnsNumofBatchProc6} -> _CnsNumofBatchProc6;
              _ -> ?DEF_MQ_INTERVAL_MIN
          end},
         {?PROP_MQ_SYNC_DC_2,
          case application:get_env(leo_storage, ?PROP_MQ_SYNC_DC_2) of
              {ok, _CnsInterval5_Min} -> _CnsInterval5_Min;
              _ -> ?DEF_MQ_INTERVAL_MIN
          end},
         {?PROP_MQ_SYNC_DC_3,
          case application:get_env(leo_storage, ?PROP_MQ_SYNC_DC_3) of
              {ok, _CnsInterval5_Max} -> _CnsInterval5_Max;
              _ -> ?DEF_MQ_INTERVAL_MAX
          end},
         %% compare metadata with dc
         {?PROP_MQ_COMP_DC_1,
          case application:get_env(leo_storage, ?PROP_MQ_COMP_DC_1) of
              {ok, _CnsNumofBatchProc7} -> _CnsNumofBatchProc7;
              _ -> ?DEF_MQ_INTERVAL_MIN
          end},
         {?PROP_MQ_COMP_DC_2,
          case application:get_env(leo_storage, ?PROP_MQ_COMP_DC_2) of
              {ok, _CnsInterval6_Min} -> _CnsInterval6_Min;
              _ -> ?DEF_MQ_INTERVAL_MIN
          end},
         {?PROP_MQ_COMP_DC_3,
          case application:get_env(leo_storage, ?PROP_MQ_COMP_DC_3) of
              {ok, _CnsInterval6_Max} -> _CnsInterval6_Max;
              _ -> ?DEF_MQ_INTERVAL_MAX
          end}
        ]).

%% Retrieve a quorum bv a method
-define(quorum(_Method,_W,_D), case _Method of
                                   ?CMD_PUT    -> _W;
                                   ?CMD_DELETE -> _D;
                                   _ -> _W
                               end).

%% For Multi-DC Replication
-define(DEF_PREFIX_MDCR_SYNC_PROC_1, "leo_mdcr_sync_w1_").
-define(DEF_PREFIX_MDCR_SYNC_PROC_2, "leo_mdcr_sync_w2_").
-define(DEF_MDCR_SYNC_PROC_BUFSIZE, 1024 * 1024 * 32).  %% 32MB
-define(DEF_MDCR_SYNC_PROC_TIMEOUT, timer:seconds(30)). %% 30sec
-define(DEF_MDCR_REQ_TIMEOUT,       timer:seconds(30)). %% 30sec
-define(DEF_MDCR_SYNC_PROCS, 1).
-define(DEF_RPC_LISTEN_PORT, 13075).
-define(DEF_MAX_RETRY_TIMES, 3).

-define(DEF_BIN_CID_SIZE,  16).     %% clusterid-size
-define(DEF_BIN_META_SIZE, 16).     %% metadata-size
-define(DEF_BIN_OBJ_SIZE,  32).     %% object-size
-define(DEF_BIN_PADDING, <<0:64>>). %% footer

-ifdef(TEST).
-define(env_mdcr_sync_proc_buf_size(), 1024).
-define(env_mdcr_sync_proc_timeout(),    30).
-define(env_mdcr_req_timeout(),       30000).
-define(env_num_of_mdcr_sync_procs(),     1).
-define(env_rpc_port(), ?DEF_RPC_LISTEN_PORT).

-else.
-define(env_mdcr_sync_proc_buf_size(),
        case application:get_env(leo_storage, mdcr_size_of_stacked_objs) of
            {ok, _MDCRSyncProcBufSize} -> _MDCRSyncProcBufSize;
            _ -> ?DEF_MDCR_SYNC_PROC_BUFSIZE
        end).
-define(env_mdcr_sync_proc_timeout(),
        case application:get_env(leo_storage, mdcr_stacking_timeout) of
            {ok, _MDCRSyncProcTimeout} ->  timer:seconds(_MDCRSyncProcTimeout);
            _ -> ?DEF_MDCR_SYNC_PROC_TIMEOUT
        end).
-define(env_mdcr_req_timeout(),
        case application:get_env(leo_storage, mdcr_req_timeout) of
            {ok, _MDCRReqTimeout} -> _MDCRReqTimeout;
            _ -> ?DEF_MDCR_REQ_TIMEOUT
        end).
-define(env_num_of_mdcr_sync_procs(),
        case application:get_env(leo_storage, mdcr_stacking_procs) of
            {ok, _NumOfMDCRSyncProcs} -> _NumOfMDCRSyncProcs;
            _ -> ?DEF_MDCR_SYNC_PROCS
        end).
-define(env_rpc_port(),
        case application:get_env(leo_rpc, listen_port) of
            {ok, _ListenPort} -> _ListenPort;
            _ -> ?DEF_RPC_LISTEN_PORT
        end).
-endif.

%% @doc types.
%%
-type(queue_type() :: ?QUEUE_TYPE_PER_OBJECT  |
                      ?QUEUE_TYPE_SYNC_BY_VNODE_ID  |
                      ?QUEUE_TYPE_REBALANCE |
                      ?QUEUE_TYPE_ASYNC_DELETION |
                      ?QUEUE_TYPE_RECOVERY_NODE |
                      ?QUEUE_TYPE_SYNC_OBJ_WITH_DC |
                      ?QUEUE_TYPE_COMP_META_WITH_DC |
                      ?QUEUE_TYPE_DEL_DIR
                      ).

-type(queue_id()   :: ?QUEUE_ID_PER_OBJECT |
                      ?QUEUE_ID_SYNC_BY_VNODE_ID |
                      ?QUEUE_ID_REBALANCE |
                      ?QUEUE_ID_ASYNC_DELETION |
                      ?QUEUE_ID_RECOVERY_NODE |
                      ?QUEUE_ID_SYNC_OBJ_WITH_DC |
                      ?QUEUE_ID_COMP_META_WITH_DC |
                      ?QUEUE_ID_DEL_DIR
                      ).
