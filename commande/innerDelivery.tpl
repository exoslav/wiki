
{* Bread crumb *}
{include file=$serverTPL|cat:'page/commande/include/breadcrumb.tpl'}

{capture name="basket_confirmation_link" assign=sBasketConfirmationLink}{getActionUrl univers='commande' action='basket_confirmation'}{/capture}

<h1 class="pageTitle">
  {trad nom_projet=$smarty.const.ORDER_MOBILE tag="select_delivery"}
</h1>

<p>
  <a class="iLink"
    href="{if (true === isset($bIsGuestCheckout))
          && (true === $bIsGuestCheckout)}
          {getActionUrl univers='commande' action='order_guest_subscription'}
        {else}
          {getActionUrl univers='commande' action='basket_confirmation'}
        {/if}">
    <i id="back_btn" class="icon-arrow-left"></i>
    <span>{trad nom_projet=$smarty.const.ORDER_MOBILE tag="back"}</span>
  </a>
</p>

{if (0 < $aUnavailableProducts|@count
  || 0 < $aSupplierErrors|@count
  || (
    false === empty($aErrorMessages)
    && false === isset($aErrorMessages.bNightMode)
    && false === isset($aErrorMessages.bSmallBoxPremium)
    && false === isset($aErrorMessages.bPNCSmallBoxPremium)
    && false === isset($aErrorMessages.bBigBoxSlotUnavailable)
  )
)}
{assign var = bDeliveryDisabled value = true}
{else}
{assign var = bDeliveryDisabled value = false}
{/if}

{if false === empty($aNormalSBREProducts)}
  {foreach from=$aNormalSBREProducts key='sSupplierId' item='aSupplierData'}
    {foreach from=$aSupplierData.aProducts item='aProduct'}
      {if 0 === $aProduct.aHomeDeliveryAvailabilityData.aStandard.iIsAvailable
        && 0 === $aProduct.aHomeDeliveryAvailabilityData.aExpress.iIsAvailable}
        {assign var = bDeliveryDisabled value = true}
      {/if}
    {/foreach}
  {/foreach}
{/if}

{* Main form *}
<form class="row" method="POST" action="//{getCurrentUrl}">

  <input type="hidden" name="subaction" value="order_delivery">

  <div id="delivery-app">
    <script>
      {strip}
      {literal}
        var deliveryTables = [];
        var deliveryDisabled = {/literal}{if $bDeliveryDisabled}true{else}false{/if}{literal};
        var deliveryTablesTranslate = {
          feedback: '{/literal}
            {trad nom_projet=$smarty.const.FO_BASKET_CONFIRMATION_MOBILE
              tag="delivery_slot_msg"}'
          {literal},
          feedbackSDD: '{/literal}
            {trad nom_projet=$smarty.const.FO_BASKET_CONFIRMATION_MOBILE
            tag="delivery_slot_msg_sdd"}'
            {literal},
          tabletHelperText: '{/literal}
            {trad nom_projet=$smarty.const.FO_DELIVERY_MOBILE
              tag="delivery_slots_tablet_helper"}'
          {literal},
          desktopHelperText: '{/literal}
            {trad nom_projet=$smarty.const.FO_DELIVERY_MOBILE
              tag="delivery_slots_desktop_helper"}'
          {literal},
          earliestDateText: '{/literal}
            {trad nom_projet=$smarty.const.FO_DELIVERY_MOBILE
              tag="delivery_slots_earliest_date"}'
          {literal},
          nextDayText: '{/literal}
            {trad nom_projet=$smarty.const.FO_DELIVERY_MOBILE
              tag="delivery_slots_next_day"}'
          {literal},
          todayText: '{/literal}
            {trad nom_projet=$smarty.const.FO_DELIVERY_MOBILE
              tag="delivery_slots_today"}'
          {literal},
          headerReplacement: '{/literal}
            {trad nom_projet=$smarty.const.FO_BASKET_CONFIRMATION_MOBILE
              tag="delivery_slots_header_replacement"}'
          {literal},
          firstAvailableDeliveryDay: '{/literal}
            {trad nom_projet=$smarty.const.FO_BASKET_CONFIRMATION_MOBILE
              tag="delivery_first_available_day"}'
          {literal},
          dayHelper: '{/literal}
            {trad nom_projet=$smarty.const.FO_BASKET_CONFIRMATION_MOBILE
              tag="delivery_day_helper"}'
          {literal},
          error: '{/literal}
            {trad nom_projet=$smarty.const.ORDER_MOBILE
              tag="unavailable_premium"}<br>
            {trad nom_projet=$smarty.const.DELIVERY_MOBILE
              tag="delivery_premium_unavailable"}'
          {literal}
        };
      {/literal}
      {/strip}
    </script>
  </div>

  <div class="col9" role="main">

    <noscript>
      <div class="msg msg-red mod">
        {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="no_javascript"}
      </div>
    </noscript>

  {* Errors *}
  {if 0 < $aUnavailableProducts|@count
    || false === empty($aErrorMessages)
    || true === isset($sDeliveryWarning)}

    <div class="msg msg-red mod">
      {* Unavailable products *}

      {if $aUnavailableProducts|@count > 0}
        <p>
          {trad nom_projet=$smarty.const.ORDER_MOBILE
            tag="items_not_available"}
        </p>
        <ul class="simple">
          {foreach from=$aUnavailableProducts item=aUnavailableProduct}
          <li>{$aUnavailableProduct.sLabel}</li>
          {/foreach}
        </ul>
        <p>
          <strong>
            {trad nom_projet=$smarty.const.ORDER_MOBILE tag="you_can_now"}
          </strong>
        </p>
        <ul>
          <li>
            <a href="{getActionUrl action='order_delivery'
                  univers='commande'
                  subaction='order_delivery'
                  info=$sToDeleteProducts}"
              class="btn-delete">
              {trad nom_projet=$smarty.const.ORDER_MOBILE tag="delete_products"}
            </a>
          </li>
          <li>
            <a href="{if (true === isset($bIsGuestCheckout)) && (true === $bIsGuestCheckout)}
              {getActionUrl univers='commande' action='order_guest_subscription'}
            {else}
              {getActionUrl univers='commande' action='delivery_address'}
            {/if}"
              class="btn-change">
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag="change_delivery_address"}
            </a>
          </li>
        </ul>
      {/if}

      {if false === empty($aErrorMessages)}

        {* Forced forward big boxes *}
        {if isset($aErrorMessages.aForwardBigBox) === true }
          <p>
            <strong>
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag="items_available_forward_title"}
            </strong>
          </p>
          <p>
            {trad nom_projet=$smarty.const.ORDER_MOBILE
              tag="items_available_forward_info"}
          </p>
          <ul class="simple">
            {foreach from=$aErrorMessages.aForwardBigBox.aErrorOrderData
              item="aUnavailableProduct" }
              <li>{$aUnavailableProduct.sLabel}</li>
            {/foreach}
          </ul>
          {$aErrorMessages.aForwardBigBox.sErrorCode}
        {/if}

        {* Forced forward trade place *}
        {if isset($aErrorMessages.aForwardSHD) === true }
          <p>
            <strong>
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag="items_available_forward_title"}
            </strong>
          </p>
          <p>
            {trad nom_projet=$smarty.const.ORDER_MOBILE
              tag="items_available_forward_info"}
          </p>
          <ul>
            {foreach from=$aErrorMessages.aForwardSHD.aErrorOrderData
              item="aUnavailableProduct" }
              <li>{$aUnavailableProduct.sLabel}</li>
              {/foreach}
          </ul>
          {$aErrorMessages.aForwardSHD.sErrorCode}
        {/if}

        {* Small box forced forward *}
        {if isset($aErrorMessages.aForwardSmallBox) === true }
          <p>
            <strong>
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag="items_available_forward_title"}
            </strong>
          </p>
          <p>
            {trad nom_projet=$smarty.const.ORDER_MOBILE
            tag="items_available_forward_info"}
          </p>
          <ul>
            {foreach from=$aErrorMessages.aForwardSmallBox.aErrorOrderData
              item="sProductId" }
              {foreach from=$aPreForProducts item="aPreForwardProduct"}
                {if $sProductId == $aPreForwardProduct.sProductId}
                  <li>{$aPreForwardProduct.sLabel}</li>
                {/if}
              {/foreach}
            {/foreach}
          </ul>
        {/if}

        {* SBRE stock error *}
        {if isset($aErrorMessages.aStockErrorsSBRE) === true }
          <p>
            <strong>{trad nom_projet=$smarty.const.ORDER_MOBILE tag="items_available_sbre_title"}</strong>
          </p>
          <p>{trad nom_projet=$smarty.const.ORDER_MOBILE tag="items_available_sbre_info"}</p>
          <ul>
            {foreach from=$aErrorMessages.aStockErrorsSBRE.aErrorOrderData item="aStockErrorProductsSBRE" }
              <li>{$aStockErrorProductsSBRE.sLabel}</li>
            {/foreach}
          </ul>
        {/if}

        {* Night mode active *}
        {if isset($aErrorMessages.bNightMode) === true}
          <p>
            <strong>
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag="night_mode_warning"}
            </strong>
          </p>
        {$aErrorMessages.bNightMode.sErrorCode}
        {/if}

        {* Big box slot error *}
        {if isset($aErrorMessages.bBigBoxSlotUnavailable) === true}
          <p>
            <strong>
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag="big_box_slot_warning"}
            </strong>
          </p>
          {$aErrorMessages.bBigBoxSlotUnavailable.sErrorCode}
        {/if}

        {* Premium switched off *}
        {if isset($aErrorMessages.bSmallBoxPremium) === true}
          <p>
            <strong>
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag="delivery_premium_unavailable"}
            </strong>
          </p>
          {$aErrorMessages.bSmallBoxPremium.sErrorCode}
        {/if}

        {* PNC Premium switched off *}
        {if isset($aErrorMessages.bPNCSmallBoxPremium) === true}
          <p>
            <strong>
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag="pnc_delivery_premium_unavailable"}
            </strong>
          </p>
          {$aErrorMessages.bPNCSmallBoxPremium.sErrorCode}
        {/if}

        {* Cut Off Time on Bigbox and Smallbox *}
        {if true === isset($aErrorMessages.bCutOffTime)}
          <p>
            <strong>
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag='delivery_cut_off_time'}
            </strong>
          </p>
          {$aErrorMessages.bCutOffTime.sErrorCode}
        {/if}

      {else}

        {if true === isset($sDeliveryWarning)}
          <strong>
            {trad nom_projet=$smarty.const.ORDER_MOBILE tag=$sDeliveryWarning}
          </strong>
        {/if}

      {/if}
    </div>
  {/if}

  {* information message on post code for a supplier delivery *}
  {foreach from=$aSupplierWarnings item='aWarning' name='SHDErrors'}
    <p class="alert">
      <strong>{$aWarning.aErrorOrderData.ERROR_MESSAGE}</strong>
    </p>
  {/foreach}

  <!-- BB -->
  {if false === empty($aNormalBigBoxProducts)
    || false === empty($aPreForBigBoxProducts)}
    <section class="tsp" data-delivery="large">
      <header>
        <h4>
          {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="big_box"}
        </h4>
      </header>
      <p>
        {trad nom_projet=$smarty.const.DELIVERY_MOBILE
        tag="explain_big_box"}
      </p>

      {if true === $bBBDeliveryOption}
      <div class="delivery-prd plug b-bottom mod">
        <label>
          <strong>
            {trad nom_projet=$smarty.const.DELIVERY_MOBILE
            tag="select_delivery_option"}
          </strong>
        </label>
        <ul class="optlist">
          <li>
            <input type="radio" id="delivery-as-few"
              name="iBBDeliveryOption"
              onclick='this.blur();'
              onchange='javascript:submit();'
              class="deliveryType"
              value="{$smarty.const.DELIVERY_OPTION_AS_FEW}"
              {if $smarty.const.DELIVERY_OPTION_AS_FEW == $iBBDeliveryOption}
              checked="checked"
              {/if}/>
            &nbsp;
            <label for="delivery-as-few">
              {trad nom_projet=$smarty.const.DELIVERY_MOBILE
                tag="delivery_as_few"}
            </label>
          </li>
          <li>
            <input type="radio" id="delivery-as-fast"
              name="iBBDeliveryOption"
              onclick='this.blur();'
              onchange='javascript:submit();'
              class="deliveryType"
              value="{$smarty.const.DELIVERY_OPTION_AS_FAST}"
              {if $smarty.const.DELIVERY_OPTION_AS_FAST == $iBBDeliveryOption}
              checked="checked"
              {/if}/>
            &nbsp;
            <label for="delivery-as-fast">
              {trad nom_projet=$smarty.const.DELIVERY_MOBILE
                tag="delivery_as_fast"}
            </label>
          </li>
        </ul>
      </div>
      {/if}

      {if false === empty($aNormalBigBoxProducts)}
        {foreach from=$aNormalBigBoxProducts item='aProduct'}
        <div class="delivery-prd plug b-bottom mod">
          <img width="67" height="60"
            alt="{$aProduct.sFullLabel}"
            src="{$aProduct.sImageUrl}">
          <strong class="prd-name left-sp">{$aProduct.sFullLabel}</strong>
        </div>
        {/foreach}
      {/if}

      {if false === empty($aPreForBigBoxProducts)
        && $smarty.const.DELIVERY_OPTION_AS_FEW == $iBBDeliveryOption }
        {foreach from=$aPreForBigBoxProducts item='aProduct'}
        <div class="delivery-prd plug b-bottom mod">
          <img width="67" height="60"
            alt="{$aProduct.sFullLabel}"
            src="{$aProduct.sImageUrl}">
          <strong class="prd-name left-sp">{$aProduct.sFullLabel}</strong>
          {if true===$aProduct.bIsForward || true===$aProduct.bIsAvailableForForward}
            <div class="msg msg-orange msg-bubble msg-bubble-top">
              {capture name="forward_product_warning" assign=sForwardProductWarning}{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="forward_product"}{/capture}
              {$sForwardProductWarning|replace:"[#LINK#]":$sBasketConfirmationLink}
            </div>
          {/if}
        </div>
        {/foreach}
      {/if}

      {if $smarty.const.DELIVERY_OPTION_AS_FEW !== $iBBDeliveryOption
        && true === isset($aDeliveryDatesBB)
        && count($aDeliveryDatesBB) > 0}
          {section name="BB_DateOccurs"
            loop=$iNbBBDateGrid
            start=0
            max=$iNbBBDateGrid}
            {assign var=iIndexCalendar
              value=$smarty.section.BB_DateOccurs.index}

        <div id="schedule-{$smarty.section.BB_DateOccurs.index}">

{* content replaced by React*}
<script>
{strip}
{literal}
deliveryTables.push({
{/literal}
  "id": "schedule-{$smarty.section.BB_DateOccurs.index}",
  "type": "BB",
  "nightMode": {if isset($aErrorMessages.bNightMode) === true}true{else}false{/if},
  "name": "sDeliveryDateChoiceBB[{$iIndexCalendar}]",
  "schedule": [
  {foreach from=$aAllPeriodsBB
    item='aPeriod' name='periods'}
    {assign var='sPeriodId' value=$aPeriod.iSlotCode}
    {ldelim}
    "header": "{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag=$aPeriod.sLabel}",
    "slots": [
    {foreach from=$aDeliveryDatesBB
      item='aDate' name='dates'}
      {ldelim}
      "name": "sDeliveryDateChoiceBB[{$iIndexCalendar}]",
      "date": "{$aDate.sDate}",
      {if true === isset($aDate.aPeriods.$sPeriodId.sLabel)}
      "value": "{$aDate.sDate}|{$sPeriodId}",
      "price": {if $smarty.section.BB_DateOccurs.index == 0}
                "{$aDate.aPeriods.$sPeriodId.sPrice}"
               {else}null{/if},
      "disabled": {if false === $bContinue}true{else}false{/if},
      "checked": {if true === isset($aDate.bSelected.$iIndexCalendar)
                  && true === $aDate.bSelected.$iIndexCalendar
                  && $aDate.aPeriods.$sPeriodId.bSelected}
                 true
                 {else}
                 false
                 {/if}
      {else}
      "disabled": true
      {/if}
      {rdelim}
      {if not $smarty.foreach.dates.last},{/if}
    {/foreach}
    ]
    {rdelim}
    {if not $smarty.foreach.periods.last},{/if}
  {/foreach}
{literal}
]});
{/literal}
{/strip}
</script>

      </div>
      {/section}
    {/if}

    {if false === empty($aPreForBigBoxProducts)
      && $smarty.const.DELIVERY_OPTION_AS_FAST == $iBBDeliveryOption }
      {foreach from=$aPreForBigBoxProducts item='aProduct'}
      <div class="delivery-prd plug b-bottom mod">
        <img width="67" height="60"
          alt="{$aProduct.sFullLabel}"
          src="{$aProduct.sImageUrl}"/>
        <strong class="prd-name left-sp">{$aProduct.sFullLabel}</strong>
        {if true===$aProduct.bIsForward || true===$aProduct.bIsAvailableForForward}
          <div class="msg msg-orange msg-bubble msg-bubble-top">
            {capture name="forward_product_warning" assign=sForwardProductWarning}{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="forward_product"}{/capture}
            {$sForwardProductWarning|replace:"[#LINK#]":$sBasketConfirmationLink}
          </div>
          {/if}
      </div>
      {/foreach}
    {/if}

    {if false === empty($aPreForBigBoxProducts)
      && true === isset($sForwardDeliveryFeeBB)}
      <span>
        {trad nom_projet=$smarty.const.DELIVERY_MOBILE
        tag="forward_allday_deliveryfee"}
        {$sForwardDeliveryFeeBB}
      </span>
    {/if}
    </section>
  {/if}
  <!-- END BB -->

  <!-- SHD -->
  {foreach
    from=$aSupplierErrors
    key='sSupplier'
    item='aSupplierError'
    name='SHDErrors'}
    {assign var='sTagSupplier' value=$sSupplier|lower}
    <section class="mod" data-delivery="tradeplace">
      <header>
        <h4>
          {trad nom_projet=$smarty.const.DELIVERY_MOBILE
            tag="shd_unable_to_deliver"}
        </h4>
      </header>
      <strong>
        {trad nom_projet=$smarty.const.DELIVERY_MOBILE
          tag="shd_supplier_$sTagSupplier"}
      </strong>
      <p>
        {trad nom_projet=$smarty.const.DELIVERY_MOBILE
          tag="explain_shd_bigbox"}
      </p>

      {foreach from=$aSupplierError.aErrorOrderData.FUPIDS item='aProduct'}
        {assign var='sErrorMessage'
          value=$aSupplierError.aErrorOrderData.ERROR_MESSAGE}

        <div class="delivery-prd plug b-bottom mod">
          <img width="67" height="60"
            alt="{$aProduct.sFullLabel}" src="{$aProduct.sImageUrl}"/>
            <strong class="prd-name left-sp">{$aProduct.sFullLabel}</strong>
        </div>

        <div class="msg msg-red msg-bubble msg-bubble-top">
          <p>{$sErrorMessage}</p>
          {if 'SHD-330' == $aSupplierError.sErrorCode}
            <a href="{getActionUrl univers='commande'
                        action='basket_confirmation'}"
              class="iLink">
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag="reduce_to_delete_products"}
            </a>
            <br>
            <span>
              and place another order for the additional quantity required.
            </span>
          {else}
            <a href="{getActionUrl action='order_delivery'
                      univers='commande' subaction='order_delivery'
                      info=$aToDeleteProductsSHD.$sSupplier}"
              class="iLink">
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag="delete_products"}
            </a>
            <br>
            <a href="{if (true === isset($bIsGuestCheckout))
                        && (true === $bIsGuestCheckout)}
                      {getActionUrl univers='commande'
                        action='order_guest_subscription'}
                      {else}
                      {getActionUrl univers='commande'
                        action='delivery_address'}
                      {/if}"
              class="iLink">
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag="change_delivery_address"}
            </a>
          {/if}
        </div>
      {/foreach}
    </section>
  {/foreach}

  {if true === isset($aNormalSHDProducts) &&
    false === empty($aNormalSHDProducts)}
    {foreach from=$aNormalSHDProducts
      key='sSupplier'
      item='aSupplierProducts'
      name="SHDBrand"}
    {foreach from=$aSupplierProducts
      key='iTransporterID'
      item='aTransporterProducts'
      name="SHDTransporter"}
      {assign var='sTagSupplier' value=$sSupplier|lower}

      <section class="tsp" data-delivery="tradeplace">
        <header>
          <h4>
            {trad
              nom_projet=$smarty.const.DELIVERY_MOBILE
              tag="shd_bigbox"}
          </h4>
        </header>
        <p>
          {trad
            nom_projet=$smarty.const.DELIVERY_MOBILE
            tag="explain_shd_bigbox"}
        </p>
        {foreach from=$aTransporterProducts item='aProduct'}
        <div class="delivery-prd plug b-bottom mod">
          <img width="67" height="60"
            alt="{$aProduct.sFullLabel}"
            src="{$aProduct.sImageUrl}"/>
          <div class="prd-name left-sp">
            <strong>
              {$aProduct.sFullLabel}
            </strong>
            <div>
              <span class="label-online-only">{trad nom_projet=$smarty.const.PRODUCT_PAGE tag="online_only"}</span>
            </div>
          </div>
        </div>
        {/foreach}

        {if true === isset($aSupplierErrors.$sSupplier)}
        {assign var='sErrorMessage'
          value=$aSupplierError.aErrorOrderData.ERROR_MESSAGE}

          <div class="msg msg-blue msg-bubble msg-bubble-top">
            <p><strong>{$sErrorMessage}.</strong></p>
            <a href="{getActionUrl action='order_delivery'
                univers='commande'
                subaction='order_delivery'
                info=$aToDeleteProductsSHD.$sSupplier}"
                class="iLink">
              <i class="icon-trash"></i>
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag="delete_products"}
            </a>
            <br>
            <a href="{
              if (true === isset($bIsGuestCheckout))
              && (true === $bIsGuestCheckout)}
                {getActionUrl univers='commande'
                  action='order_guest_subscription'}
              {else}
                {getActionUrl univers='commande'
                action='delivery_address'}
              {/if}"
              class="iLink">
              <i class="icon-edit"></i>
              {trad nom_projet=$smarty.const.ORDER_MOBILE
                tag="change_delivery_address"}
            </a>
          </div>

        {else}

<div id="schedule-shd-{$smarty.foreach.SHDBrand.index}{$smarty.foreach.SHDTransporter.index}">

{* content replaced by React*}
<script>
{strip}
{literal}
deliveryTables.push({
{/literal}
  "id": "schedule-shd-{$smarty.foreach.SHDBrand.index}{$smarty.foreach.SHDTransporter.index}",
  "type": "SHD",
  "name": "sDeliveryDateChoiceSHD[{$sSupplier}-{$iTransporterID}]",
  "arrangeDate": {ldelim}
    "label": "{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="shd_call_me"}",
    "value": "SHDCallMe"
  {rdelim},
  "schedule": [
  {foreach from=$aAllPeriodsSHD.$sSupplier.$iTransporterID
    item='aPeriod' name='periods'}
    {assign var='sPeriodId' value=$aPeriod.iSlotCode}
  {ldelim}
  "header": "{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag=$aPeriod.sLabel}",
  "slots": [
    {foreach from=$aDeliveryDatesSHD.$sSupplier.$iTransporterID
      item="aDateByTransporter" name="dates_chunk_shd"}
      {ldelim}
      "name": "sDeliveryDateChoiceSHD[{$sSupplier}-{$iTransporterID}]",
      "date": "{$aDateByTransporter.sDate}",
      {if true === isset($aDateByTransporter.aPeriods.$sPeriodId.sLabel)
        && true == $aDateByTransporter.bAvailable}
      "value": "{$aDateByTransporter.sDate}|{$sPeriodId}",
      "price": "{$aDateByTransporter.aPeriods.$sPeriodId.sPrice}",
      "disabled": {if false === $bContinue}true{else}false{/if},
      "checked": {if true === isset($aDateByTransporter.bSelected)
                  && true === $aDateByTransporter.bSelected
                  && $aDateByTransporter.aPeriods.$sPeriodId.bSelected}
                 true
                 {else}
                 false
                 {/if}
      {else}
      "disabled": true
      {/if}
      {rdelim}
      {if not $smarty.foreach.dates_chunk_shd.last},{/if}
    {/foreach}
  ]
  {rdelim}
  {if not $smarty.foreach.periods.last},{/if}
{/foreach}
{literal}
]});
{/literal}
{/strip}
</script>

</div>
        {/if}
      </section>
    {/foreach}
  {/foreach}
{/if}

{if true === isset($aPreForSHDProducts)
  && false === empty($aPreForSHDProducts)}
  <section class="orderItem" data-delivery="tradeplace">
    <header>
      <h4>
        {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="shd_bigbox"}
        <small>
          <strong>
            {trad nom_projet=$smarty.const.DELIVERY_MOBILE
              tag="shd_supplier_$sTagSupplier"}
          </strong>
        </small>
      </h4>
    </header>

    {foreach from=$aPreForSHDProducts
      key='sSupplier' item='aSupplierProducts'}
      {foreach from=$aSupplierProducts
        key='iTransporterID'
        item='aTransporterProducts'
        name="SHDTransporter"}
        {assign var='sTagSupplier' value=$sSupplier|lower}
        <strong>
          {trad nom_projet=$smarty.const.DELIVERY_MOBILE
            tag="shd_supplier_$sTagSupplier"}
        </strong>
        <p>
          {trad nom_projet=$smarty.const.DELIVERY_MOBILE
            tag="explain_shd_bigbox"}
        </p>

        {if false === empty($aNormalSHDProducts)
          || false === empty($aPreForSHDProducts)}
          {if true === isset($aSHDDeliveryOption.$sSupplier.bSHDDeliveryOption)
            &&  true === $aSHDDeliveryOption.$sSupplier.bSHDDeliveryOption}
            <div class="delivery-prd plug product b-bottom">
              <label>
                <strong>
                  {trad nom_projet=$smarty.const.DELIVERY_MOBILE
                    tag="select_delivery_option"}
                </strong>
              </label>
              <ul>
                <li>
                  <input type="radio" id="delivery-as-few"
                    name="iSHDDeliveryOption"
                    class="deliveryType"
                    value="{$sSupplier}_{$smarty.const.DELIVERY_OPTION_AS_FEW}"
                    {if $smarty.const.DELIVERY_OPTION_AS_FEW == $aSHDDeliveryOption.$sSupplier.IdOptionType}
                    checked="checked"
                    {/if}/>
                  &nbsp;
                  <label for="delivery-as-few">
                    {trad nom_projet=$smarty.const.DELIVERY_MOBILE
                    tag="delivery_as_few"}
                  </label>
                </li>
                <li>
                  <input type="radio" id="delivery-as-fast"
                    name="iSHDDeliveryOption"
                    class="deliveryType"
                    value="{$sSupplier}_{$smarty.const.DELIVERY_OPTION_AS_FAST}"
                    {if $smarty.const.DELIVERY_OPTION_AS_FAST == $aSHDDeliveryOption.$sSupplier.IdOptionType}
                    checked="checked"
                    {/if}/>
                  &nbsp;
                  <label for="delivery-as-fast">
                    {trad nom_projet=$smarty.const.DELIVERY_MOBILE
                    tag="delivery_as_fast"}
                  </label>
                </li>
              </ul>
            </div>
            {/if}
          {/if}

          {foreach from=$aTransporterProducts item='aProduct'}
            <div class="delivery-prd plug b-bottom mod">
              <img width="67" height="60" alt="{$aProduct.sFullLabel}"
                src="{$aProduct.sImageUrl}"/>
              <strong class="prd-name left-sp">{$aProduct.sFullLabel}</strong>
            </div>
          {/foreach}

          <div class="plug">
            <div>
              {trad nom_projet=$smarty.const.DELIVERY_MOBILE
                tag="shd_forward"}
            </div>
            <div class="msg msg-orange msg-bubble msg-bubble-top">
              {capture name="explain_shd_forward" assign=sExplainShdForward}{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="explain_shd_forward"}{/capture}
              {$sExplainShdForward|replace:'[#LINK#]':$sBasketConfirmationLink}
            </div>
          </div>

          <div class="plug">
            <span>
              {if true === isset($aForwardDeliveryFeeSHD.$sSupplier)}
                {$aForwardDeliveryFeeSHD.$sSupplier}
              {else}
                {trad nom_projet=$smarty.const.DELIVERY_MOBILE
                  tag="delivery_free"}
              {/if}
            </span>
          </div>

        </section>
      {/foreach}
    {/foreach}
  {/if}
  <!-- END SHD -->

  <!-- SB -->
  {if false === empty($aNormalSmallBoxProducts)
    || false === empty($aPreForSmallBoxProducts)
    || false === empty($aNormalSBREProducts)}

    <section class="mod" data-delivery="small">

      {if false === empty($aNormalSmallBoxProducts)
      || false === empty($aPreForSmallBoxProducts)}
        <header>
          <h4>
            {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="small_box"}
          </h4>
        </header>
      {/if}

      {if false === empty($aNormalSmallBoxProducts)}

        <p>
          {trad nom_projet=$smarty.const.DELIVERY_MOBILE
            tag="explain_small_box"}
        </p>

        {if false === empty($aNormalSmallBoxProducts)}
          {foreach from=$aNormalSmallBoxProducts item=aProduct}
            <div class="delivery-prd plug b-bottom mod">
              <img width="67" height="60"
                alt="{$aProduct.sFullLabel}"
                src="{$aProduct.sImageUrl}"/>
              <strong class="prd-name left-sp">
                {if 1 < $aProduct.iQuantity}
                  ({$aProduct.iQuantity}
                  {trad nom_projet=$smarty.const.ITEM_DETAILS_MOBILE tag='of'})
                {/if}
                {$aProduct.sFullLabel}
              </strong>
            </div>
          {/foreach}
        {/if}

        {* add other items on as few case *}
        {if false === empty($aPreForSmallBoxProducts)
          && $smarty.const.DELIVERY_OPTION_AS_FEW == $iSBDeliveryOption }
          {foreach from=$aPreForSmallBoxProducts item=aProduct}
            <div class="delivery-prd plug b-bottom mod">
              <img width="67" height="60"
                alt="{$aProduct.sFullLabel}" src="{$aProduct.sImageUrl}"/>
              <strong class="prd-name left-sp">{$aProduct.sFullLabel}</strong>
              {if true===$aProduct.bIsForward}
                <div class="msg msg-orange msg-bubble msg-bubble-top">
                  {trad nom_projet=$smarty.const.DELIVERY_MOBILE
                    tag="forward_product"}
                </div>
              {else}
                <br>{trad nom_projet=$smarty.const.DELIVERY_MOBILE
                  tag="pre_product"}
              {/if}
              <br>({$aProduct.sAvailability})
            </div>
          {/foreach}
        {/if}

        {if true === $bSBDeliveryOption}
          <div class="delivery-prechoice">
            <div class="delivery-prechoice-legend">
              <strong>
                {trad nom_projet=$smarty.const.DELIVERY_MOBILE
                  tag="select_delivery_option"}
              </strong>
            </div>
            <div class="delivery-prechoice-options">
              <ul>
                <li>
                  <input type="radio" id="delivery-as-few" name="iSBDeliveryOption"
                    value="{$smarty.const.DELIVERY_OPTION_AS_FEW}"
                    {if $smarty.const.DELIVERY_OPTION_AS_FEW == $iSBDeliveryOption}
                      checked="checked"
                    {/if} />
                  <label for="delivery-as-few">
                    {trad nom_projet=$smarty.const.DELIVERY_MOBILE
                      tag="delivery_as_few"}
                  </label>
                </li>
                <li>
                  <input type="radio" id="delivery-as-fast" name="iSBDeliveryOption"
                    value="{$smarty.const.DELIVERY_OPTION_AS_FAST}"
                    {if $smarty.const.DELIVERY_OPTION_AS_FAST == $iSBDeliveryOption}
                      checked="checked"
                    {/if} />
                  <label for="delivery-as-fast">
                    {trad nom_projet=$smarty.const.DELIVERY_MOBILE
                      tag="delivery_as_fast"}
                  </label>
                </li>
              </ul>
            </div>
          </div>
        {/if}

        {if false === empty($aNormalSmallBoxProducts)}
          <div id="deliverySB">

{* JSON used and content replaced by React *}
<script>
  {strip}
    deliveryTables.push({ldelim}
      "id": "deliverySB",
      "type": "SB",
      "name": "sDeliveryDateChoiceSB",
      "scheduleURL": "{$sURLEnquiryPremiumSB}",
      "SBChoice": {ldelim}
      "label": "{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="choose_delivery_type"}",
        "name": "iNormalSmallBoxDeliveryType",
        "options": {literal} [ {/literal}
          {ldelim}
            "label": "<strong>{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="delivery_standard"}</strong> - <strong>{$sNormalDeliveryFeesSB}</strong> {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="delivery_standard_desc"}",
            "value": "{$smarty.const.DELIVERY_TYPE_STANDARD}",
            "checked": {if $smarty.const.DELIVERY_TYPE_STANDARD == $iNormalSmallBoxDeliveryType
                        || true === isset($aErrorMessages.bSmallBoxPremium)}
                      true {else} false {/if},
            "icon": "DeliverySlot",
            "deliveryType": "standardDelivery"
          {rdelim}
          {if false === empty($aNormalSmallBoxProducts)
            && $smarty.const.DELIVERY_OPTION_AS_FEW != $iSBDeliveryOption
            && false === isset($aErrorMessages.bSmallBoxPremium)}
          {literal} ,{ {/literal}
            "label": "<strong>{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="flexible_delivery"}</strong> - {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="flexible_delivery"}",
            "value": "{$smarty.const.DELIVERY_TYPE_PREMIUM}",
            "checked": {if $smarty.const.DELIVERY_TYPE_PREMIUM == $iNormalSmallBoxDeliveryType}
                      true {else} false {/if},
            "icon": "Delivery",
            "deliveryType": "flexibleDelivery"
          {rdelim}
          ,{ldelim}
            "label": "<strong>Today delivery</strong>",
            "value": "99",
            "checked": false,
            "deliveryType": "sameDayDelivery",
            "icon": "DeliveryToday"
          {rdelim}
        {/if}
        {literal} ]} {/literal}
    {literal} }); {/literal}
  {/strip}
</script>

          </div>
          <div id="deliverySB1">
          </div>
        {/if}

      {/if}

      {* do the split on as fast case *}
      {if false === empty($aPreForSmallBoxProducts)
        && $smarty.const.DELIVERY_OPTION_AS_FAST == $iSBDeliveryOption}
        {foreach from=$aPreForSmallBoxProducts item=aProduct}
          <div class="delivery-prd plug b-bottom mod">
            <img width="67" height="60" alt="{$aProduct.sFullLabel}"
              src="{$aProduct.sImageUrl}">
            <strong class="prd-name left-sp">{$aProduct.sFullLabel}</strong>
            {if true===$aProduct.bIsForward}
              <div class="msg msg-orange msg-bubble msg-bubble-top">
                {trad nom_projet=$smarty.const.DELIVERY_MOBILE
                  tag="forward_product"}
              </div>
            {else}
              {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="pre_product"}
            {/if}
            <br>({$aProduct.sAvailability})
          </div>
        {/foreach}
        <div class="delivery-prd plug b-bottom product mod">
          <label for="super-saver-SB">
            {trad nom_projet=$smarty.const.DELIVERY_MOBILE
              tag="delivery_standard"}
          </label>
          <span class="productTitle">
            {trad nom_projet=$smarty.const.DELIVERY_MOBILE
              tag="delivery_standard_desc"}
          </span>
          <span class="prd-amount">{$sTotalPreForSBDeliveryFees}</span>
        </div>
      {/if}

      {* SBRE *}
      {if false === empty($aNormalSBREProducts)}
      {foreach from=$aNormalSBREProducts key='sSupplierId' item='aSupplierData'}

        <div class="delivery-options-group">
          <header>
            <h4>
              {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="small_box"}
            </h4>
          </header>

          <p>
            {trad nom_projet=$smarty.const.DELIVERY_MOBILE
            tag="explain_small_box"}
          </p>

        {foreach from=$aSupplierData.aProducts item='aProduct'}
        {assign var="bIsExpressDelivery" value=$aProduct.bIsExpressDelivery}
        {assign var="iDaysForDelivery" value=$aProduct.iDaysForDelivery}
        {assign var="iExpressDeliveryCharge" value=$aProduct.iExpressDeliveryCharge}

        <div class="delivery-prd plug b-bottom mod">
          <img width="67" height="60" alt="{$aProduct.sFullLabel}" src="{$aProduct.sImageUrl}"/>
          <div class="prd-name left-sp">
            <span class="productTitle">{if 1 < $aProduct.iQuantity}({$aProduct.iQuantity} {trad nom_projet=$smarty.const.ITEM_DETAILS_MOBILE tag='of'}) {/if} {$aProduct.sFullLabel}</span>
            <div>
              <span class="label-online-only">{trad nom_projet=$smarty.const.PRODUCT_PAGE tag="online_only"}</span>
              {if $smarty.const.SBRE_ORDER_PROCESS_DIRECTLY_FROM_SUPPLIER_TEXT}
              <p class="label-online-only-desc"><small>{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="sbre_delivery_description"}</small></p>
              {/if}
            </div>
          </div>
        </div>
        {/foreach}

        <div class="delivery-prechoice deliveryType tsp">
          <div class="delivery-prechoice-legend">
            {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="choose_delivery_type"}
          </div>

          <div class="delivery-prechoice-options">
            <ul>
              <li>
                <input type="radio" name="aNormalSBREDeliveryType[{$sSupplierId|escape}]"
                  id="sbre-normal-{$sSupplierId|escape}"
                  value="{$smarty.const.DELIVERY_TYPE_SBRE_STANDARD}"
                  {if $smarty.const.DELIVERY_TYPE_SBRE_STANDARD == $aSupplierData.iDeliveryType}checked="checked" {/if}
                  data-available="{$aProduct.aHomeDeliveryAvailabilityData.aStandard.iIsAvailable}"
                  data-unavailable-header="{$aProduct.aHomeDeliveryAvailabilityData.aStandard.sHeader|escape:'htmlall'}"
                  data-unavailable-content="{$aProduct.aHomeDeliveryAvailabilityData.aStandard.sContent|escape:'htmlall'}"
                />
                <label for="sbre-normal-{$sSupplierId|escape}">
                  {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="sbre_delivery_free_home" drap="[#DAYS#]="|cat:$iDaysForDelivery|escape}
                </label>
              </li>

              {if $bIsExpressDelivery}
              <li>
                <input type="radio" name="aNormalSBREDeliveryType[{$sSupplierId|escape}]"
                  id="sbre-express-{$sSupplierId|escape}" value="{$smarty.const.DELIVERY_TYPE_SBRE_EXPRESS}"
                  {if $smarty.const.DELIVERY_TYPE_SBRE_EXPRESS == $aSupplierData.iDeliveryType}checked="checked" {/if}
                  data-available="{$aProduct.aHomeDeliveryAvailabilityData.aExpress.iIsAvailable}"
                  data-unavailable-header="{$aProduct.aHomeDeliveryAvailabilityData.aExpress.sHeader|escape:'htmlall'}"
                  data-unavailable-content="{$aProduct.aHomeDeliveryAvailabilityData.aExpress.sContent|escape:'htmlall'}"
                />
                <label for="sbre-express-{$sSupplierId|escape}">
                  {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="sbre_delivery_express" drap="[#PRICE#]="|cat:$iExpressDeliveryCharge|escape}
                </label>
              </li>
              {/if}
            </ul>
          </div>
        </div>

      </div>
      {/foreach}
      {/if}
      {* END SBRE *}

    </section>
    {/if}
    <!-- END SB & SBRE -->

    <!-- P&C SB & SBRE -->
    {if false === empty($aPNCSmallBoxProducts) || false === empty($aPncSBREProducts)}
      <section class="tsp" data-delivery="payAndCollect">
        <header>
          <h4>
            {trad
              nom_projet=$smarty.const.DELIVERY_MOBILE
              tag="small_box_pnc"}
          </h4>
        </header>

        <p>
          {trad
            nom_projet=$smarty.const.DELIVERY_MOBILE
            tag="explain_small_box_pnc"}
        </p>

        {foreach from=$aPNCSmallBoxProducts item=aProduct}
          <div class="delivery-prd plug b-bottom mod">
            <img width="67" height="60" alt="{$aProduct.sFullLabel}"
              src="{$aProduct.sImageUrl}"/>
            <strong class="prd-name left-sp">{$aProduct.sFullLabel}</strong>
          </div>
        {/foreach}

        {if false === empty($aPNCSmallBoxProducts)}
        <div class="msg msg-blue msg-bubble msg-bubble-top mod">
          <div class="pc-msg-left">
            {trad
              nom_projet=$smarty.const.DELIVERY_MOBILE
              tag="items_delivered_at_store"}
          </div>
          <div class="pc-msg-right selected-store">
            <div class="in">
              <div class="bsp">
                {if true === $aStore.aStoreLogo.bIsCPWStore}
                  <img src="{$serverGFX}images/logos/cpw-logo.png"
                    alt="Carphone Warehouse" width="140" height="25"
                    class="img-logo cpw-logo" />
                {/if}
                {if true === $aStore.aStoreLogo.bIsCurrysStore}
                  <small class="cys">Currys</small>
                {/if}
                {if true === $aStore.aStoreLogo.bIsPCWorldStore}
                  <small class="pcw">PC World</small>
                {/if}
                <br/>
                <strong>{$aStore.sDescription}</strong><br/>
                {if false === $aStore.aStoreLogo.bIsCurrysStore
                  && false === $aStore.aStoreLogo.bIsPCWorldStore}
                  <a href="#popu" class="toggleControler lk simple-lk">
                    {trad
                      nom_projet=$smarty.const.BASKET_CONFIRMATION_MOBILE
                      tag='pick_up_point_only'}
                  </a>
                  <br/>
                  <div id="popu">
                    <p>
                    <small>
                      {trad
                        nom_projet=$smarty.const.BASKET_CONFIRMATION_MOBILE
                        tag='pick_up_just_from_this_store'}
                    </small>
                    </p>
                  </div>
                {/if}
                {if !empty($aStore.sAddress1)}{$aStore.sAddress1}<br />{/if}
                {if !empty($aStore.sAddress2)}{$aStore.sAddress2}<br />{/if}
                {if !empty($aStore.sAddress3)}{$aStore.sAddress3}<br />{/if}
                {if !empty($aStore.sTown)}{$aStore.sTown}, {/if}
                {if !empty($aStore.sPostCode)}{$aStore.sPostCode}{/if}
              </div>
              <input type="hidden" name="sStoreKeyword"
                id="store-finder-1" value="{$sStoreKeyword}"/>
              <a class="lk"
                href="{getActionUrl action="basket_confirmation" univers="commande" subaction="initorder" product="delStore-y"}">
                {trad
                  nom_projet=$smarty.const.BASKET_CONFIRMATION_MOBILE
                  tag='change_store'}
              </a>
            </div>
          </div>
          <div class="clearfix"></div>
        </div>
        {/if}


        {if false === empty($aPNCSmallBoxProducts)}
        <div id="deliveryPnC">

{* JSON used and content replaced by React *}
<script>
  {strip}
    deliveryTables.push({ldelim}
      "id": "deliveryPnC",
      "type": "SB",
      "name": "sDeliveryDateChoicePNC",
      "scheduleURL": "{$sURLEnquiryPremiumSB}",
      "SBChoice": {ldelim}
      "label": "{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="choose_delivery_type_pnc"}",
        "name": "iNormalPNCDeliveryType",
        "options": {literal} [ {/literal}
          {ldelim}
          "label": "<strong>{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="delivery_standard_pnc"}</strong> - <strong>{$sNormalDeliveryFeesPNC}</strong> {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="delivery_standard_desc_pnc"}",
            "value": "{$smarty.const.DELIVERY_TYPE_STANDARD_PNC}",
            "checked": {if $smarty.const.DELIVERY_TYPE_STANDARD_PNC == $iNormalPNCDeliveryType
                        || true === isset($aErrorMessages.bPNCPremium)}
                      true {else} false {/if}
          {rdelim}
          {if false === empty($aPNCSmallBoxProducts)
            && isset($aErrorMessages.bPNCSmallBoxPremium) === false}
          {literal} ,{ {/literal}
            "label": "<strong>{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="flexible_delivery_pnc"}</strong> - {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="flexible_delivery_desc_pnc"}",
            "value": "{$smarty.const.DELIVERY_TYPE_PREMIUM_PNC}",
            "checked": {if $smarty.const.DELIVERY_TYPE_PREMIUM_PNC == $iNormalPNCDeliveryType}
                      true {else} false {/if}
          {rdelim}
          {/if}
        {literal} ]} {/literal}
    {literal} }); {/literal}
  {/strip}
</script>

          </div>
          {/if}

          {* P&C SBRE *}
          {if false === empty($aPncSBREProducts)}
            {foreach from=$aPncSBREProducts key='sSupplierId' item='aSupplierData'}
            <div class="delivery-options-group">
              {foreach from=$aSupplierData.aProducts item='aProduct'}
              {assign var="iDaysForDelivery" value=$aProduct.iDaysForDelivery}
              <div class="delivery-prd plug b-bottom mod">
                <img width="45" height="40" alt="{$aProduct.sFullLabel}" src="{$aProduct.sImageUrl}"/>
                <div class="prd-name left-sp">
                  {$aProduct.sFullLabel}
                  <div>
                    <span class="label-online-only">{trad nom_projet=$smarty.const.PRODUCT_PAGE tag="online_only"}</span>
                    {if $smarty.const.SBRE_ORDER_PROCESS_DIRECTLY_FROM_SUPPLIER_TEXT}
                    <p class="label-online-only-desc"><small>{trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="sbre_delivery_description"}</small></p>
                    {/if}
                  </div>
                </div>
              </div>
              {/foreach}

              <div class="msg msg-blue msg-bubble msg-bubble-top mod">
                <div class="pc-msg-left">
                  {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="items_delivered_at_store"}
                </div>
                <div class="pc-msg-right selected-store">
                  <div class="in">
                    <div class="bsp">
                      {if true === $aStore.aStoreLogo.bIsCPWStore}
                        <img src="{$serverGFX}images/logos/cpw-logo.png"
                          alt="Carphone Warehouse" width="140" height="25"
                          class="img-logo cpw-logo" />
                      {/if}
                      {if true === $aStore.aStoreLogo.bIsCurrysStore}
                        <small class="cys">Currys</small>
                      {/if}
                      {if true === $aStore.aStoreLogo.bIsPCWorldStore}
                        <small class="pcw">PC World</small>
                      {/if}
                      <br/>
                      <strong>{$aStore.sDescription}</strong><br/>
                      {if false === $aStore.aStoreLogo.bIsCurrysStore && false === $aStore.aStoreLogo.bIsPCWorldStore}
                        <a href="#popu-sbre-{$sSupplierId|escape}" class="toggleControler lk simple-lk">
                          {trad nom_projet=$smarty.const.BASKET_CONFIRMATION_MOBILE tag='pick_up_point_only'}
                        </a>
                        <br/>
                        <div id="popu-sbre-{$sSupplierId|escape}">
                          <p>
                          <small>
                            {trad nom_projet=$smarty.const.BASKET_CONFIRMATION_MOBILE tag='pick_up_just_from_this_store'}
                          </small>
                          </p>
                        </div>
                      {/if}
                      {if !empty($aStore.sAddress1)}{$aStore.sAddress1}<br />{/if}
                      {if !empty($aStore.sAddress2)}{$aStore.sAddress2}<br />{/if}
                      {if !empty($aStore.sAddress3)}{$aStore.sAddress3}<br />{/if}
                      {if !empty($aStore.sTown)}{$aStore.sTown}, {/if}{if !empty($aStore.sPostCode)}{$aStore.sPostCode}{/if}
                    </div>
                    <a class="lk"
                      href="{getActionUrl action="basket_confirmation" univers="commande" subaction="initorder" product="delStore-y"}">
                      {trad nom_projet=$smarty.const.BASKET_CONFIRMATION_MOBILE tag='change_store'}
                    </a>
                  </div>
                </div>
                <div class="clearfix"></div>
              </div>

              <div class="deliveryType delivery-prechoice">
                <div class="delivery-prechoice-legend">
                  {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="choose_delivery_type_pnc"}
                </div>
                <div class="delivery-prechoice-options">
                  <ul class="optlist">
                    <li>
                      <input type="radio"
                        id="super-saver-PNC-sbre-{$sSupplierId|escape}"
                        checked="checked"
                        name="aPncSBREDeliveryType[{$sSupplierId|escape}]"
                        value="{$smarty.const.DELIVERY_TYPE_SBRE_PNC}"
                      />
                      <label for="super-saver-PNC-sbre-{$sSupplierId|escape}">
                        {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="sbre_delivery_free_pnc" drap="[#DAYS#]="|cat:$iDaysForDelivery|escape}
                      </label>
                    </li>
                  </ul>
                </div>
              </div>

            </div>
            {/foreach}
          {/if}
        {* END P&C SBRE *}


      </section>
    {/if}
    <!-- END P&C SB -->

    <!-- DOWNLOAD -->
    {if false === empty($aNormalSoftwareDownloadProducts)}
    <section class="tsp" data-delivery="download">
      <header>
        <h4>
          {trad nom_projet=$smarty.const.DELIVERY_MOBILE tag="download"}
        </h4>
      </header>
      {foreach from=$aNormalSoftwareDownloadProducts item=aProduct}
        <div class="delivery-prd plug b-bottom mod">
          <img width="67" height="60" alt="{$aProduct.sFullLabel}"
            src="{$aProduct.sImageUrl}"/>
          <strong class="prd-name left-sp">{$aProduct.sFullLabel}</strong>
        </div>
      {/foreach}
      <div class="msg msg-blue msg-bubble msg-bubble-top mod">
        {trad
          nom_projet=$smarty.const.BASKET_CONFIRMATION_MOBILE
          tag='download_basket_details'}
      </div>
    </section>
    {/if}
    <!-- END DOWNLOAD -->
    <div id="formSubmitContainer">
      <div class="delivery-submit-container">
        {* content replaced by React *}
        <button type="submit" name="delivery_validate" id="formSubmit"
          class="button-primary-cta"
          {if $bDeliveryDisabled}
            disabled
          {/if}>
            {trad nom_projet=$smarty.const.ORDER_MOBILE tag="continue"}
        </button>
      </div>
    </div>
  </div>

  <div id="fixed" class="col3" role="complementary">
    <div id="formSubmitContainerClone" class="desktop">
      {* content replaced by React *}
      <button id="formSubmit" class="button-primary-cta" type="submit"
        name="delivery_validate"
        {if $bDeliveryDisabled}
          disabled
        {/if}>
        {trad nom_projet=$smarty.const.ORDER_MOBILE tag="continue"}
      </button>
    </div>

    {* Right block *}
    {foreach from=$RightBlocksList item=b}
      {$b}
    {/foreach}

    {* Trust Indicators (icons) *}
    {include file=$serverTPL|cat:'page/commande/include/trustIndicators.tpl'}
    {* Accept payment (icons) *}
    {include file=$serverTPL|cat:'page/commande/include/boxOrderServices.tpl'}
  </div>
</form>
