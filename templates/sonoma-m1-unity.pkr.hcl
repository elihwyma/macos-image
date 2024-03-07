packer {
    required_plugins {
      tart = {
        version = ">= 1.2.0"
        source  = "github.com/cirruslabs/tart"
      }
    }
  }
  
  source "tart-cli" "tart" {
    from_ipsw    = "https://updates.cdn-apple.com/2024WinterFCS/fullrestores/042-78241/B45074EB-2891-4C05-BCA4-7463F3AC0982/UniversalMac_14.3_23D56_Restore.ipsw"
    vm_name      = "sonoma-m1-unity"
    cpu_count    = 4
    memory_gb    = 6
    disk_size_gb = 120
    ssh_password = "admin"
    ssh_username = "admin"
    ssh_timeout  = "120s"
    boot_command = [
      # hello, hola, bonjour, etc.
      "<wait60s><spacebar>",
      # Language Selection
      "<wait5s><esc><enter>",
      # Region
      "<wait10s><leftShiftOn><tab><leftShiftOff><spacebar>",
      # Written and Spoken Languages
      "<wait5s><leftShiftOn><tab><leftShiftOff><spacebar>",
      # Accessibility
      "<wait5s><leftShiftOn><tab><leftShiftOff><spacebar>",
      # Privacy
      "<wait5s><leftShiftOn><tab><leftShiftOff><spacebar>",
      # Migration
      "<wait5s><tab><tab><tab><spacebar>",
      # Apple ID
      "<wait5s><leftShiftOn><tab><tab><leftShiftOff><spacebar><wait1s><tab><spacebar>",
      # Terms and Conditions
      "<wait5s><leftShiftOn><tab><spacebar><leftShiftOff><wait1s><tab><spacebar>",
      # Account Creation
      "<wait5s>admin<tab><tab>admin<tab>admin<tab><tab><tab><spacebar>",
      # Location Services
      "<wait45s><leftShiftOn><tab><leftShiftOff><spacebar><tab><spacebar>",
      # Region
      "<wait5s><leftShiftOn><tab><leftShiftOff><spacebar>",
      # Analytics
      "<wait5s><leftShiftOn><tab><leftShiftOff><spacebar>",
      # Screen Time
      "<wait5s><tab><spacebar>",
      # Siri
      "<wait5s><tab><spacebar><leftShiftOn><tab><leftShiftOff><spacebar>",
      # Appearance
      "<wait5s><leftShiftOn><tab><leftShiftOff><spacebar>",
      # Welcome
      # Enable Voice Over
      "<wait10s><leftAltOn><f5><leftAltOff><wait5s>v",
      # Now that the installation is done, open "System Settings"
      "<wait10s><leftAltOn><spacebar><leftAltOff>System Settings<enter>",
      # Navigate to "Sharing"
      "<wait10s><leftAltOn>f<leftAltOff>sharing<enter>",
      # Navigate to "Screen Sharing" and enable it
      "<wait10s><tab><tab><tab><tab><tab><spacebar>",
      # Navigate to "Remote Login" and enable it
      "<wait10s><tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><spacebar>",
      # Disable Voice Over
      "<leftAltOn><f5><leftAltOff>",
    ]
  
    // A (hopefully) temporary workaround for Virtualization.Framework's
    // installation process not fully finishing in a timely manner
    create_grace_time = "30s"
  }
  
  build {
    sources = ["source.tart-cli.tart"]
  
    provisioner "shell" {
      inline = [
        // Enable passwordless sudo
        "echo admin | sudo -S sh -c \"mkdir -p /etc/sudoers.d/; echo 'admin ALL=(ALL) NOPASSWD: ALL' | EDITOR=tee visudo /etc/sudoers.d/admin-nopasswd\"",
        // Enable auto-login
        //
        // See https://github.com/xfreebird/kcpassword for details.
        "echo '00000000: 1ced 3f4a bcbc ba2c caca 4e82' | sudo xxd -r - /etc/kcpassword",
        "sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser admin",
        // Disable screensaver at login screen
        "sudo defaults write /Library/Preferences/com.apple.screensaver loginWindowIdleTime 0",
        // Disable screensaver for admin user
        "defaults -currentHost write com.apple.screensaver idleTime 0",
        // Prevent the VM from sleeping
        "sudo systemsetup -setdisplaysleep Off 2>/dev/null",
        "sudo systemsetup -setsleep Off 2>/dev/null",
        "sudo systemsetup -setcomputersleep Off 2>/dev/null",
        // Launch Safari to populate the defaults
        "/Applications/Safari.app/Contents/MacOS/Safari &",
        "SAFARI_PID=$!",
        "disown",
        "sleep 30",
        "kill -9 $SAFARI_PID",
        // Enable Safari's remote automation
        "sudo safaridriver --enable",
        // Disable screen lock
        //
        // Note that this only works if the user is logged-in,
        // i.e. not on login screen.
        "sysadminctl -screenLock off -password admin",
      ]
    }
    provisioner "shell" {
      inline = [
        "echo 'Disabling spotlight...'",
        "sudo mdutil -a -i off",
      ]
    }
    provisioner "shell" {
      inline = [
        "touch ~/.zprofile",
        "ln -s ~/.zprofile ~/.profile",
      ]
    }
    provisioner "shell" {
      inline = [
        "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"",
        "echo \"export LANG=en_US.UTF-8\" >> ~/.zprofile",
        "echo 'eval \"$(/opt/homebrew/bin/brew shellenv)\"' >> ~/.zprofile",
        "echo \"export HOMEBREW_NO_AUTO_UPDATE=1\" >> ~/.zprofile",
        "echo \"export HOMEBREW_NO_INSTALL_CLEANUP=1\" >> ~/.zprofile",
        "source ~/.zprofile",
        "brew --version",
        "brew update",
        "brew install dotnet@6 git aria2 wget cmake gcc git-lfs jq gh curl gnu-tar python@3.11 ninja sccache make libyaml rbenv ldid xz",
        "git lfs install"
      ]
    }
    provisioner "shell" {
        inline = [
            "echo 'Installing Rosetta 2'",
            "sudo softwareupdate --install-rosetta --agree-to-license"
        ]
    }
    provisioner "shell" {
      inline = [
        "source ~/.zprofile",
        "echo 'Installing Unity 2022.3.20f1'",
        "wget https://download.unity3d.com/download_unity/61c2feb0970d/MacEditorInstallerArm64/Unity-2022.3.20f1.pkg",
        "sudo installer -pkg Unity-2022.3.20f1.pkg -target /",
        "rm Unity-2022.3.20f1.pkg",
        "echo 'Installing macOS and Windows Build Support'",
        "wget https://download.unity3d.com/download_unity/61c2feb0970d/MacEditorTargetInstaller/UnitySetup-Mac-IL2CPP-Support-for-Editor-2022.3.20f1.pkg",
        "wget https://download.unity3d.com/download_unity/61c2feb0970d/MacEditorTargetInstaller/UnitySetup-Windows-Mono-Support-for-Editor-2022.3.20f1.pkg",
        "sudo installer -pkg UnitySetup-Mac-IL2CPP-Support-for-Editor-2022.3.20f1.pkg -target /",
        "rm UnitySetup-Mac-IL2CPP-Support-for-Editor-2022.3.20f1.pkg",
        "sudo installer -pkg UnitySetup-Windows-Mono-Support-for-Editor-2022.3.20f1.pkg -target /",
        "rm UnitySetup-Windows-Mono-Support-for-Editor-2022.3.20f1.pkg",
        "/Applications/Unity/Unity.app/Contents/MacOS/Unity -quit -batchmode || true"
      ]
    }
    provisioner "shell" {
      inline = [
        "source ~/.zprofile",
        "echo 'Installing Git Runner Firmware'",
        "mkdir actions-runner && cd actions-runner",
        "curl -o actions-runner-osx-arm64-2.314.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.314.1/actions-runner-osx-arm64-2.314.1.tar.gz && tar xzf ./actions-runner-osx-arm64-2.314.1.tar.gz"
      ]
    }
  }
  