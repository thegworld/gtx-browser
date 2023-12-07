#include "chrome/browser/ui/views/toolbar/chrome_wallet_button.h"

#include "chrome/browser/ui/browser.h"
#include "chrome/browser/ui/browser_tabstrip.h"
#include "chrome/browser/ui/view_ids.h"
#include "chrome/common/webui_url_constants.h"
#include "ui/base/metadata/metadata_impl_macros.h"
#include "ui/resources/grit/ui_resources.h"
#include "ui/views/accessibility/view_accessibility.h"
#include "ui/views/controls/button/button_controller.h"
#include "url/gurl.h"

#include "chrome/browser/extensions/extension_view_host.h"
#include "chrome/browser/ui/views/extensions/extension_popup.h"

#include "chrome/browser/ui/browser_navigator.h"
#include "chrome/browser/ui/browser_navigator_params.h"

#define VIEW_ID_CHROME_WALLET_BUTTON 52513

ChromeWalletButton::ChromeWalletButton(Browser* browser)
    : ToolbarButton(PressedCallback()), browser_(browser) {
  DCHECK(browser_);

  button_controller()->set_notify_action(
      views::ButtonController::NotifyAction::kOnPress);
  SetTriggerableEventFlags(ui::EF_LEFT_MOUSE_BUTTON);

  SetID(VIEW_ID_CHROME_WALLET_BUTTON);
  SetFlipCanvasOnPaintForRTLUI(false);
  GetViewAccessibility().OverrideName(u"ChromeWalletButton");
  SetHorizontalAlignment(gfx::ALIGN_CENTER);
}

ChromeWalletButton::~ChromeWalletButton() = default;

void ChromeWalletButton::UpdateIcon() {
  UpdateExistingIcon();
}

void ChromeWalletButton::Layout() {
  ToolbarButton::Layout();

  image()->SetHorizontalAlignment(views::ImageView::Alignment::kCenter);
  image()->SetVerticalAlignment(views::ImageView::Alignment::kTrailing);
  gfx::Size image_size = image()->GetImage().size();
  image_size.Enlarge(1, 1);
  image()->SetSize(image_size);
}

void ChromeWalletButton::NotifyClick(const ui::Event& event) {
  Button::NotifyClick(event);
  chrome::AddTabAt(browser_, GURL(chrome::kChromeChromeWalletURL), -1, true);

  // std::unique_ptr<extensions::ExtensionViewHost> host(new extensions::ExtensionViewHost(
  //     NULL, NULL, GURL(chrome::kChromeChromeWalletURL),
  //     extensions::mojom::ViewType::kExtensionPopup, NULL));
  // // auto host = std::make_unique<extensions::ExtensionViewHost>(NULL, NULL, GURL(chrome::kChromeChromeWalletURL),
  // //     extensions::mojom::ViewType::kExtensionPopup, NULL);

  // // extensions::ExtensionViewHost host(NULL, NULL,
  // // GURL(chrome::kChromeChromeWalletURL),
  // //                           extensions::mojom::ViewType::kExtensionPopup,
  // //                           NULL);

  // ExtensionPopup::ShowPopup(host, NULL, views::BubbleBorder::Arrow::TOP_LEFT,
  //                           ExtensionPopup::ShowAction::SHOW);

  // NavigateParams params(browser_, GURL(chrome::kChromeChromeWalletURL),
  //                       ui::PAGE_TRANSITION_TYPED);
  // params.disposition = WindowOpenDisposition::NEW_POPUP;
  // params.window_bounds = gfx::Rect(400, 600);
  // params.window_action = NavigateParams::SHOW_WINDOW;
  // params.user_gesture = true;

  // chrome::ConfigureTabGroupForNavigation( &params );

  // Navigate(&params);
}
// chrome://favicon2/?size=24&scale_factor=1x&show_fallback_monogram=&page_url=chrome://wallet
void ChromeWalletButton::UpdateExistingIcon() {
  SetImageModel(ButtonState::STATE_NORMAL,
                ui::ImageModel::FromResourceId(IDR_DEFAULT_CHROME_WALLET_ICON));
  // SetImageModel(ButtonState::STATE_HOVERED,
  //               ui::ImageModel::FromResourceId(IDR_DEFAULT_CHROME_WALLET_HOVERED_ICON));
  // SetImageModel(ButtonState::STATE_PRESSED,
  //               ui::ImageModel::FromResourceId(IDR_DEFAULT_CHROME_WALLET_PRESSED_ICON));
  // SetImageModel(Button::STATE_DISABLED,
  //               ui::ImageModel::FromResourceId(IDR_DEFAULT_CHROME_WALLET_DISABLED_ICON));
}

BEGIN_METADATA(ChromeWalletButton, ToolbarButton)
END_METADATA
