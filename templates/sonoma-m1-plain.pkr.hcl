packer {
  required_plugins {
    tart = {
      version = ">= 1.2.0"
      source  = "github.com/cirruslabs/tart"
    }
  }
}

source "tart-cli" "tart" {
  from_ipsw    = "https://updates.cdn-apple.com/2024SummerFCS/fullrestores/052-69922/F5DA2B64-25EB-4370-9E89-FA5689859796/UniversalMac_14.6_23G80_Restore.ipsw"
  vm_name      = "sonoma-m1-plain"
  cpu_count    = 11
  memory_gb    = 24
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
}
