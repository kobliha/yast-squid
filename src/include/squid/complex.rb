# encoding: utf-8

# ------------------------------------------------------------------------------
# Copyright (c) 2006 Novell, Inc. All Rights Reserved.
#
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of version 2 of the GNU General Public License as published by the
# Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, contact Novell, Inc.
#
# To contact Novell about this file by physical or electronic mail, you may find
# current contact information at www.novell.com.
# ------------------------------------------------------------------------------

# File:	include/squid/complex.ycp
# Package:	Configuration of squid
# Summary:	Dialogs definitions
# Authors:	Daniel Fiser <dfiser@suse.cz>
#
# $Id: complex.ycp 29363 2006-03-24 08:20:43Z mzugec $
module Yast
  module SquidComplexInclude
    def initialize_squid_complex(include_target)
      Yast.import "UI"

      textdomain "squid"

      Yast.import "Wizard"
      Yast.import "Confirm"
      Yast.import "DialogTree"
      Yast.import "CWMServiceStart"
      Yast.import "CWMFirewallInterfaces"
      Yast.import "PackageSystem"
      Yast.import "Squid"
      Yast.import "Mode"

      Yast.include include_target, "squid/helps.rb"
      Yast.include include_target, "squid/dialogs.rb"
      Yast.include include_target, "squid/handlers.rb"
      Yast.include include_target, "squid/store_del.rb"
      Yast.include include_target, "squid/inits.rb"


      @main_caption = _("Squid")

      @widget_descr = {
        "auto_start"             => CWMServiceStart.CreateAutoStartWidget(
          {
            "get_service_auto_start" => fun_ref(
              Squid.method(:IsServiceEnabled),
              "boolean ()"
            ),
            "set_service_auto_start" => fun_ref(
              Squid.method(:SetServiceEnabled),
              "void (boolean)"
            ),
            "start_auto_button"      => _("When &Booting"),
            "start_manual_button"    => _("&Manually"),
            "help"                   => Builtins.sformat(
              CWMServiceStart.AutoStartHelpTemplate,
              _("When Booting"),
              _("Manually")
            )
          }
        ),
        "start_stop"             => CWMServiceStart.CreateStartStopWidget(
          {
            "service_id"                => "squid",
            "service_running_label"     => _("Squid is running"),
            "service_not_running_label" => _("Squid is not running"),
            "start_now_button"          => _("&Start Squid Now"),
            "stop_now_button"           => _("S&top Squid Now"),
            "save_now_action"           => fun_ref(
              method(:SaveAndRestart),
              "void ()"
            ),
            "save_now_button"           => _(
              "Sa&ve Settings and Restart Squid Now"
            ),
            #"start_now_action"          : uses the default function
            #"stop_now_action"           : uses the default function
            "help"                      => Builtins.sformat(
              CWMServiceStart.StartStopHelpTemplate(true),
              # TRANSLATORS: part of help text - push button label, NO SHORTCUT!!!
              _("Start Squid Now"),
              # TRANSLATORS: part of help text - push button label, NO SHORTCUT!!!
              _("Stop Squid Now"),
              # TRANSLATORS: part of help text - push button label, NO SHORTCUT!!!
              _("Save Settings and Restart Squid Now")
            )
          }
        ),
        "firewall"               => CWMFirewallInterfaces.CreateOpenFirewallWidget(
          {
            "services"               => [Squid.GetFirewallServiceName],
            "display_details"        => true,
            "open_firewall_checkbox" => _("Open Ports in Firewall")
          }
        ),
        "http_ports_table"       => {
          "widget"        => :custom,
          "custom_widget" => HttpPortsTableWidget(),
          "init"          => fun_ref(
            method(:InitHttpPortsTable),
            "void (string)"
          ),
          "handle"        => fun_ref(
            method(:HandleHttpPortsTable),
            "symbol (string, map)"
          ),
          "help"          => Ops.get_string(@HELPS, "http_ports", "")
        },
        "refresh_patterns_table" => {
          "widget"        => :custom,
          "custom_widget" => RefreshPatternsTableWidget(),
          "init"          => fun_ref(
            method(:InitRefreshPatternsTable),
            "void (string)"
          ),
          "handle"        => fun_ref(
            method(:HandleRefreshPatternsTable),
            "symbol (string, map)"
          ),
          "help"          => Ops.get_string(@HELPS, "cache", "")
        },
        "cache2_dialog"          => {
          "widget"            => :custom,
          "custom_widget"     => Cache2DialogWidget(),
          "init"              => fun_ref(
            method(:InitCache2Dialog),
            "void (string)"
          ),
          "handle"            => fun_ref(
            method(:HandleCache2Dialog),
            "symbol (string, map)"
          ),
          "store"             => fun_ref(
            method(:StoreDataFromCache2Dialog),
            "void (string, map)"
          ),
          "validate_type"     => :function,
          "validate_function" => fun_ref(
            method(:ValidateCache2Dialog),
            "boolean (string, map)"
          ),
          "help"              => Ops.get_string(@HELPS, "cache2", "")
        },
        "cache_directory"        => {
          "widget"            => :custom,
          "custom_widget"     => CacheDirectoryDialog(),
          "init"              => fun_ref(
            method(:InitCacheDirectoryDialog),
            "void (string)"
          ),
          "handle"            => fun_ref(
            method(:HandleCacheDirectoryDialog),
            "symbol (string, map)"
          ),
          "store"             => fun_ref(
            method(:StoreDataFromCacheDirectoryDialog),
            "void (string, map)"
          ),
          "validate_type"     => :function,
          "validate_function" => fun_ref(
            method(:ValidateCacheDirectoryDialog),
            "boolean (string, map)"
          ),
          "help"              => Ops.get_string(@HELPS, "cache_directory", "")
        },
        "acl_groups_table"       => {
          "widget"        => :custom,
          "custom_widget" => ACLGroupsTableWidget(),
          "init"          => fun_ref(
            method(:InitACLGroupsTable),
            "void (string)"
          ),
          "handle"        => fun_ref(
            method(:HandleAccessControlDialog),
            "symbol (string, map)"
          ),
          "help"          => Ops.get_string(@HELPS, "acl_groups", "")
        },
        "http_access_table"      => {
          "widget"        => :custom,
          "custom_widget" => HttpAccessTableWidget(),
          "init"          => fun_ref(
            method(:InitHttpAccessTable),
            "void (string)"
          ),
          "help"          => Ops.get_string(@HELPS, "http_access", "")
        },
        "logging_frame"          => {
          "widget"            => :custom,
          "custom_widget"     => LoggingFrameWidget(),
          "init"              => fun_ref(
            method(:InitLoggingFrame),
            "void (string)"
          ),
          "handle"            => fun_ref(
            method(:HandleLoggingFrame),
            "symbol (string, map)"
          ),
          "store"             => fun_ref(
            method(:StoreDataFromLoggingFrame),
            "void (string, map)"
          ),
          "validate_type"     => :function,
          "validate_function" => fun_ref(
            method(:ValidateLoggingFrame),
            "boolean (string, map)"
          ),
          "help"              => Ops.get_string(@HELPS, "logging", "")
        },
        "timeouts_frame"         => {
          "widget"        => :custom,
          "custom_widget" => TimeoutsFrameWidget(),
          "init"          => fun_ref(
            method(:InitTimeoutsFrame),
            "void (string)"
          ),
          "help"          => Ops.get_string(@HELPS, "timeouts", "")
        },
        "miscellaneous_frame"    => {
          "widget"            => :custom,
          "custom_widget"     => MiscellaneousFrameWidget(),
          "init"              => fun_ref(
            method(:InitMiscellaneousFrame),
            "void (string)"
          ),
          "store"             => fun_ref(
            method(:StoreDataFromMiscellaneousFrame),
            "void (string, map)"
          ),
          "validate_type"     => :function,
          "validate_function" => fun_ref(
            method(:ValidateMiscellaneousFrame),
            "boolean (string, map)"
          ),
          "help"              => Ops.get_string(@HELPS, "miscellaneous", "")
        }
      }

      @screens = {
        "s1" => {
          "widget_names"    => ["auto_start", "start_stop", "firewall"],
          "contents"        => VCenter(
            HBox(
              HSpacing(3),
              VBox(
                "auto_start",
                VSpacing(),
                Mode.normal ? "start_stop" : Empty(),
                VSpacing(),
                Frame(_("Firewall Settings"), "firewall")
              ),
              HSpacing(3)
            )
          ),
          "caption"         => Ops.add(
            Ops.add(@main_caption, ": "),
            _("Start-Up")
          ),
          "tree_item_label" => _("Start-Up")
        },
        "s2" => {
          "widget_names"    => ["http_ports_table"],
          "contents"        => VBox("http_ports_table"),
          "caption"         => Ops.add(
            Ops.add(@main_caption, ": "),
            _("HTTP Ports Setting")
          ),
          "tree_item_label" => _("HTTP Ports")
        },
        "s3" => {
          "widget_names"    => ["refresh_patterns_table"],
          "contents"        => VBox("refresh_patterns_table"),
          "caption"         => Ops.add(
            Ops.add(@main_caption, ": "),
            _("Refresh Patterns Setting")
          ),
          "tree_item_label" => _("Refresh Patterns")
        },
        "s4" => {
          "widget_names"    => ["cache2_dialog"],
          "contents"        => VCenter("cache2_dialog"),
          "caption"         => Ops.add(
            Ops.add(@main_caption, ": "),
            _("Cache Setting")
          ),
          "tree_item_label" => _("Cache Setting")
        },
        "s5" => {
          "widget_names"    => ["cache_directory"],
          "contents"        => VCenter("cache_directory"),
          "caption"         => Ops.add(
            Ops.add(@main_caption, ": "),
            _("Cache Directory Setting")
          ),
          "tree_item_label" => _("Cache Directory")
        },
        "s6" => {
          "widget_names"    => ["acl_groups_table", "http_access_table"],
          "contents"        => VBox(
            "acl_groups_table",
            VSpacing(),
            "http_access_table"
          ),
          "caption"         => Ops.add(
            Ops.add(@main_caption, ": "),
            _("Access Control Setting")
          ),
          "tree_item_label" => _("Access Control")
        },
        "s7" => {
          "widget_names"    => ["logging_frame", "timeouts_frame"],
          "contents"        => HBox(
            HSpacing(3),
            VBox("logging_frame", VSpacing(), "timeouts_frame"),
            HSpacing(3)
          ),
          "caption"         => Ops.add(
            Ops.add(@main_caption, ": "),
            _("Logging and Timeouts Setting")
          ),
          "tree_item_label" => _("Logging and Timeouts")
        },
        "s8" => {
          "widget_names"    => ["miscellaneous_frame"],
          "contents"        => VBox("miscellaneous_frame"),
          "caption"         => Ops.add(
            Ops.add(@main_caption, ": "),
            _("Miscellaneous Setting")
          ),
          "tree_item_label" => _("Miscellaneous")
        }
      }

      @ids_order = ["s1", "s2", "s3", "s4", "s5", "s6", "s7", "s8"]
      @initial_screen = "s1"
    end

    def ReallyAbort
      !Squid.GetModified || Popup.ReallyAbort(true)
    end

    def PollAbort
      UI.PollInput == :abort
    end

    # Read settings dialog
    # @return `abort if aborted and `next otherwise
    def ReadDialog
      Wizard.RestoreHelp(Ops.get_string(@HELPS, "read", ""))
      Squid.AbortFunction = fun_ref(method(:PollAbort), "boolean ()")
      return :abort if !Confirm.MustBeRoot
      if !PackageSystem.CheckAndInstallPackagesInteractive(["squid"])
        return :abort
      end
      ret = Squid.Read
      ret ? :next : :abort
    end

    # Write settings dialog
    # @return `abort if aborted and `next otherwise
    def WriteDialog
      Wizard.RestoreHelp(Ops.get_string(@HELPS, "write", ""))
      Squid.AbortFunction = fun_ref(method(:PollAbort), "boolean ()")
      ret = Squid.Write
      ret ? :next : :abort
    end


    def SaveAndRestart
      Wizard.CreateDialog
      WriteDialog()
      UI.CloseDialog

      nil
    end

    def MainDialog
      DialogTree.ShowAndRun(
        {
          "ids_order"      => @ids_order,
          "initial_screen" => @initial_screen,
          "widget_descr"   => @widget_descr,
          "screens"        => @screens,
          "functions"      => {
            :abort => fun_ref(method(:ReallyAbort), "boolean ()")
          },
          "back_button"    => "",
          "next_button"    => Label.OKButton,
          "abort_button"   => Label.CancelButton
        }
      )
    end
  end
end
