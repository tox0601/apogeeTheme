<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<#if (requestAttributes.externalLoginKey)?exists><#assign externalKeyParam = "?externalLoginKey=" + requestAttributes.externalLoginKey?if_exists></#if>
<#if (externalLoginKey)?exists><#assign externalKeyParam = "?externalLoginKey=" + requestAttributes.externalLoginKey?if_exists></#if>
<#assign ofbizServerName = application.getAttribute("_serverId")?default("default-server")>
<#assign contextPath = request.getContextPath()>
<#assign displayApps = Static["org.apache.ofbiz.webapp.WebAppCache"].getShared().getAppBarWebInfos(ofbizServerName, "main")>
<#if person?has_content>
    <#assign avatarList = EntityQuery.use(delegator).from("PartyContent").where("partyId",  person.partyId!, "partyContentTypeId", "LGOIMGURL").queryList()!>
    <#if avatarList?has_content>
        <#assign avatar = Static["org.apache.ofbiz.entity.util.EntityUtil"].getFirst(avatarList)>
        <#assign avatarDetail = EntityQuery.use(delegator).from("PartyContentDetail").where("partyId", person.partyId!, "contentId", avatar.contentId!).queryFirst()!>
    </#if>
</#if>
<body>
<#include "component://common-theme/template/ImpersonateBanner.ftl"/>
<div id="wait-spinner" class="hidden">
    <div id="wait-spinner-image"></div>
</div>
<div class="page-container">
    <div class="hidden">
        <a href="#column-container" title="${uiLabelMap.CommonSkipNavigation}" accesskey="2">
        ${uiLabelMap.CommonSkipNavigation}
        </a>
    </div>
<#if userLogin?has_content>
    <#assign appMax = Static["org.apache.ofbiz.base.util.UtilProperties"].getPropertyAsInteger("rainbowstone", "appMax", 1)/>
    <#assign alreadySelected = false>
    <div id="main-navigation-bar">
    <div id="main-nav-bar-left">

        <#--<a id="homeButton" href="<@ofbizUrl>HomeMenu</@ofbizUrl>"><img id="homeButtonImage" src="/rainbowstone/images/home.svg" alt="Home"></a>-->

        <!-- If the number of applications is greater than the maximum number of applications that can be displayed, the rest is put
        in a drop-down menu. The code is deliberately doubled because otherwise, reading the code during maintenance
        could be complicated. Correct if ever the performance is affected -->
        <div class="container-more-app">
            <#assign appCount = 0>
            <#assign moreApp = false>
            <#if displayApps??>
            <#list displayApps as display>
            <#assign thisApp = display.getContextRoot()>
            <#assign permission = true>
            <#assign selected = false>
            <#assign permissions = display.getBasePermission()>
            <#list permissions as perm>
                <#if (perm != "NONE" && !security.hasEntityPermission(perm, "_VIEW", session))>
                <#-- User must have ALL permissions in the base-permission list -->
                    <#assign permission = false>
                </#if>
            </#list>
            <#if permission == true>
            <#if thisApp == contextPath || contextPath + "/" == thisApp>
                <#assign selected = true>
            </#if>
            <#assign thisApp = StringUtil.wrapString(thisApp)>
            <#assign thisURL = thisApp>
            <#if thisApp != "/">
                <#assign thisURL = thisURL + "/control/main">
            </#if>
            <#if layoutSettings.suppressTab?exists && display.name == layoutSettings.suppressTab>
            <#-- do not display this component-->
            <#else>

            <#if !moreApp>
            <div id="more-app" <#if !alreadySelected>class="selected"</#if>>
                <div class="company-logo"></div>
                <ul id="more-app-list">
                    <#assign moreApp = true>
                    </#if>
                    <li class="app-btn-sup<#if selected> selected</#if>">
                        <a class="more-app-a" href="${thisURL}${StringUtil.wrapString(externalKeyParam)}"<#if uiLabelMap?exists> title="${uiLabelMap[display.description]}">${uiLabelMap[display.title]}<#else> title="${display.description}">${display.title}</#if></a>
                        <#if selected>
                            <#assign currentMoreApp = display>
                        </#if>
                    </li>

                    <#assign appCount = appCount + 1 >
                    </#if>
                    </#if>
                    </#list>
                    </#if>
                    <#if displaySecondaryApps ??>
                    <#list displaySecondaryApps as display>
                    <#assign thisApp = display.getContextRoot()>
                    <#assign permission = true>
                    <#assign selected = false>
                    <#assign permissions = display.getBasePermission()>
                    <#list permissions as perm>
                        <#if (perm != "NONE" && !security.hasEntityPermission(perm, "_VIEW", session))>
                        <#-- User must have ALL permissions in the base-permission list -->
                            <#assign permission = false>
                        </#if>
                    </#list>
                    <#if permission == true>
                    <#if thisApp == contextPath || contextPath + "/" == thisApp>
                        <#assign selected = true>
                    </#if>
                    <#assign thisApp = StringUtil.wrapString(thisApp)>
                    <#assign thisURL = thisApp>
                    <#if thisApp != "/">
                        <#assign thisURL = thisURL + "/control/main">
                    </#if>

                    <#if !moreApp>
                    <div id="more-app">
                        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
                        <ul id="more-app-list">
                            <#assign moreApp = true>
                            </#if>
                            <li class="app-btn-sup<#if selected> selected</#if>">
                                <a class="more-app-a" href="${thisURL}${StringUtil.wrapString(externalKeyParam)}"<#if uiLabelMap?exists> title="${uiLabelMap[display.description]}">${uiLabelMap[display.title]}<#else> title="${display.description}">${display.title}</#if></a>
                                <#if selected>
                                    <#assign currentMoreApp = display>
                                </#if>
                            </li>
                            <#assign appCount = appCount + 1>
                            </#if>
                            </#list>
                            </#if>
                            <#if moreApp>
                        </ul> <!-- more-app-list -->
                    </div> <!-- more-app -->
                    </#if>

                    <#if currentMoreApp?exists>
                        <ul class="app-bar-list ">
                            <#assign thisApp = currentMoreApp.getContextRoot()>
                            <#assign thisApp = StringUtil.wrapString(thisApp)>
                            <#assign thisURL = thisApp>
                            <#if thisApp != "/">
                                <#assign thisURL = thisURL + "/control/main">
                            </#if>
                            <li class="app-btn selected">
                                <div id="app-selected">
                                    <a class="more-app-a" href="${thisURL}${StringUtil.wrapString(externalKeyParam)}"<#if uiLabelMap??> title="${uiLabelMap[currentMoreApp.description]}">${uiLabelMap[currentMoreApp.title]}<#else> title="${currentMoreApp.description}">${currentMoreApp.title}</#if></a>
                                </div>
                            </li>
                        </ul>
                    </#if>

                    <div id="main-nav-bar-right">
                <#include "./Avatar.ftl"/>
            </div>
            </div>

        </div>

    </div> <!-- main navigation bar -->
</#if>