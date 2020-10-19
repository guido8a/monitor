<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 19/10/20
  Time: 11:53
--%>


<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">

    <title>Semáforo</title>

    <asset:javascript src="/jstree-3.0.8/dist/jstree.min.js"/>
    <asset:stylesheet src="/jstree-3.0.8/dist/themes/default/style.min.css"/>

    <style type="text/css">
    #tree {
        overflow-y : auto;
        height     : 440px;
    }

    .jstree-search {
        color : #5F87B2 !important;
    }
    </style>

</head>

<body>

<div id="cargando" class="text-center">
    <p>Cargando los departamentos</p>

    <img src="${resource(dir: 'images', file: 'spinner.gif')}" alt='Cargando...' width="64px" height="64px"/>

    <p>Por favor espere</p>
</div>

<div class="row" style="margin-bottom: 10px;">

    %{--    <div class="btn-toolbar toolbar">--}%
    %{--        <div class="btn-group">--}%
    %{--            <g:link controller="inicio" action="parametros" class="btn btn-info">--}%
    %{--                <i class="fa fa-arrow-left"></i> Parámetros--}%
    %{--            </g:link>--}%
    %{--        </div>--}%
    %{--    </div>--}%

    <div class="col-md-2">
        <div class="input-group input-group-sm">
            <g:textField name="searchArbol" class="form-control input-sm" placeholder="Buscador"/>
            <span class="input-group-btn">
                <a href="#" id="btnSearchArbol" class="btn btn-sm btn-info">
                    <i class="fa fa-search"></i>&nbsp;
                </a>
            </span>
        </div><!-- /input-group -->
    </div>

    <div class="col-md-3 hidden" id="divSearchRes">
        <span id="spanSearchRes">
            5 resultados
        </span>

        <div class="btn-group">
            <a href="#" class="btn btn-xs btn-default" id="btnNextSearch" title="Siguiente">
                <i class="fa fa-chevron-down"></i>&nbsp;
            </a>
            <a href="#" class="btn btn-xs btn-default" id="btnPrevSearch" title="Anterior">
                <i class="fa fa-chevron-up"></i>&nbsp;
            </a>
            <a href="#" class="btn btn-xs btn-default" id="btnClearSearch" title="Limpiar búsqueda">
                <i class="fa fa-times-circle"></i>&nbsp;
            </a>
        </div>
    </div>

    <div class="col-md-1">
        <div class="btn-group">
            <a href="#" class="btn btn-xs btn-default" id="btnCollapseAll" title="Cerrar todos los nodos">
                <i class="fa fa-minus-square"></i>&nbsp;
            </a>
            <a href="#" class="btn btn-xs btn-default" id="btnExpandAll" title="Abrir todos los nodos">
                <i class="fa fa-plus-square"></i>&nbsp;
            </a>
        </div>
    </div>

    <div class="col-md-4 text-right pull-right" style="font-size: 18px">
        <i class="fa fa-parking text-success"></i> Provincia
        <i class="fa fa-copyright text-primary"></i> Cantón
    </div>
</div>

<div id="tree" class="well hidden">

</div>

<script type="text/javascript">
    var searchRes = [];
    var posSearchShow = 0;
    var $treeContainer = $("#tree");


    function createContextMenu(node) {
        $(".lzm-dropdown-menu").hide();

        var nodeStrId = node.id;
        var $node = $("#" + nodeStrId);
        var nodeId = nodeStrId.split("_")[1];
        var nodeType = $node.data("jstree").type;

        var esRoot = nodeType == "root";
        var esPrincipal = nodeType == "principal";
        var esCanton = nodeType.contains("canton");

        var items = {};

        var semaforo = {
            label            : "Semáforo",
            icon             : "fa fa-traffic-light text-danger",
            action           : function () {
                location.href = '${createLink(controller: 'semaforo', action: 'list')}/' + nodeId;
            }
        };

        if (esRoot) {
        } else if (esPrincipal) {
        } else if (esCanton) {
            items.semaforo = semaforo;
        }
        return items;
    }

    function scrollToNode($scrollTo) {
        $treeContainer.jstree("deselect_all").jstree("select_node", $scrollTo).animate({
            scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
        });
    }

    function scrollToRoot() {
        var $scrollTo = $("#root");
        scrollToNode($scrollTo);
    }

    function scrollToSearchRes() {
        var $scrollTo = $(searchRes[posSearchShow]).parents("li").first();
        $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + searchRes.length);
        scrollToNode($scrollTo);
    }

    $(function () {

        $treeContainer.on("loaded.jstree", function () {
            $("#cargando").hide();
            $("#tree").removeClass("hidden");

        }).on("select_node.jstree", function (node, selected, event) {
        }).jstree({
            plugins     : ["types", "state", "contextmenu", "search"],
            core        : {
                multiple       : false,
                check_callback : true,
                themes         : {
                    variant : "small",
                    dots    : true,
                    stripes : true
                },
                data           : {
                    // async : false,
                    url   : '${createLink(controller: 'semaforo' , action:"loadTreePart_ajax")}',
                    data  : function (node) {
                        return {
                            id    : node.id,
                            sort  : "${params.sort?:'nombre'}",
                            order : "${params.order?:'asc'}"
                        };
                    }
                }
            },
            contextmenu : {
                show_at_node : false,
                items        : createContextMenu
            },
            state       : {
                key : "unidades",
                opened: false
            },
            search      : {
                fuzzy             : false,
                show_only_matches : false,
                ajax              : {
                    url     : "${createLink(controller: 'semaforo', action:'arbolSearch_ajax')}",
                    success : function (msg) {
                        var json = $.parseJSON(msg);
                        $.each(json, function (i, obj) {
                            $('#tree').jstree("open_node", obj);
                        });
                        setTimeout(function () {
                            searchRes = $(".jstree-search");
                            var cantRes = searchRes.length;
                            posSearchShow = 0;
                            $("#divSearchRes").removeClass("hidden");
                            $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);
                            scrollToSearchRes();
                        }, 300);

                    }
                }
            },
            types       : {
                root                : {
                    icon : "fa fa-sitemap text-info"
                },
                yachay              : {
                    icon : "fa fa-building text-info"
                },
                unidadPadreActivo   : {
                    icon : "fa fa-building-o text-info"
                },
                unidadPadreInactivo : {
                    icon : "fa fa-building-o text-muted"
                },
                unidadHijoActivo    : {
                    icon : "fa fa-home text-success"
                },
                unidadHijoInactivo  : {
                    icon : "fa fa-home text-muted"
                },
                usuarioActivo       : {
                    icon : "fa fa-user text-info"
                },
                usuarioInactivo     : {
                    icon : "fa fa-user text-muted"
                }
            }
        });

        $("#btnExpandAll").click(function () {
            $treeContainer.jstree("open_all");
            scrollToRoot();
            return false;
        });

        $("#btnCollapseAll").click(function () {
            $treeContainer.jstree("close_all");
            scrollToRoot();
            return false;
        });

        $('#btnSearchArbol').click(function () {
            $treeContainer.jstree("open_all");
            $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));
            return false;
        });
        $("#searchArbol").keypress(function (ev) {
            if (ev.keyCode == 13) {
                $treeContainer.jstree("open_all");
                $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));
                return false;
            }
        });

        $("#btnPrevSearch").click(function () {
            if (posSearchShow > 0) {
                posSearchShow--;
            } else {
                posSearchShow = searchRes.length - 1;
            }
            scrollToSearchRes();
            return false;
        });

        $("#btnNextSearch").click(function () {
            if (posSearchShow < searchRes.length - 1) {
                posSearchShow++;
            } else {
                posSearchShow = 0;
            }
            scrollToSearchRes();
            return false;
        });

        $("#btnClearSearch").click(function () {
            $treeContainer.jstree("clear_search");
            $("#searchArbol").val("");
            posSearchShow = 0;
            searchRes = [];
            scrollToRoot();
            $("#divSearchRes").addClass("hidden");
            $("#spanSearchRes").text("");
        });

    });
</script>

</body>
</html>