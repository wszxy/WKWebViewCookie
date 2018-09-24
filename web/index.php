<?php 
  setcookie("name_test", "value_test", time()+3600);
?>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf8">
        <script type="text/javascript" src="jquery-3.3.1.min.js"></script>


    </head>

    <body>
        <p>#####################################</p>
        <h1>这是页面1</h1>
        php读取到cookie：
        <br/>
        <?php
            echo $_COOKIE["name_test"];
        ?>
        <br/>
        <p>js 读取的cookie是：<p id="js"></p></p>
        <br/>
        <a href="index2.php">跳转到页面2</a>
        <p>#####################################</p>
    </body>

        <script type="text/javascript">
          $("p#js").text(document.cookie);

    </script>
</html>
