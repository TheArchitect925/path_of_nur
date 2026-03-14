package com.pathofnur.watch.tiles

import android.content.Intent
import androidx.core.net.toUri
import androidx.wear.protolayout.ActionBuilders
import androidx.wear.protolayout.ColorBuilders
import androidx.wear.protolayout.DeviceParametersBuilders
import androidx.wear.protolayout.DimensionBuilders
import androidx.wear.protolayout.LayoutElementBuilders
import androidx.wear.protolayout.ModifiersBuilders
import com.pathofnur.watch.MainActivity

private val gold = ColorBuilders.ColorProp.Builder(0xFFE2C27Aff.toInt()).build()
private val textPrimary = ColorBuilders.ColorProp.Builder(0xFFF7F1DEff.toInt()).build()
private val surface = ColorBuilders.ColorProp.Builder(0xFF14171Eff.toInt()).build()

fun text(value: String, size: Float, emphasized: Boolean): LayoutElementBuilders.LayoutElement =
    LayoutElementBuilders.Text.Builder()
        .setText(value)
        .setFontStyle(
            LayoutElementBuilders.FontStyle.Builder()
                .setColor(if (emphasized) gold else textPrimary)
                .setSize(DimensionBuilders.sp(size))
                .build()
        )
        .build()

fun button(label: String, action: ActionBuilders.Action): LayoutElementBuilders.LayoutElement =
    LayoutElementBuilders.Box.Builder()
        .setModifiers(
            ModifiersBuilders.Modifiers.Builder()
                .setClickable(
                    ModifiersBuilders.Clickable.Builder()
                        .setId(label)
                        .setOnClick(action)
                        .build()
                )
                .setBackground(
                    ModifiersBuilders.Background.Builder()
                        .setColor(surface)
                        .setCorner(ModifiersBuilders.Corner.Builder().setRadius(DimensionBuilders.dp(18f)).build())
                        .build()
                )
                .setPadding(
                    ModifiersBuilders.Padding.Builder()
                        .setAll(DimensionBuilders.dp(10f))
                        .build()
                )
                .build()
        )
        .addContent(text(label, 14f, false))
        .build()

fun materialTile(
    title: String,
    main: List<LayoutElementBuilders.LayoutElement>,
    bottom: List<LayoutElementBuilders.LayoutElement>,
    clickable: ActionBuilders.Action
): LayoutElementBuilders.LayoutElement {
    val column = LayoutElementBuilders.Column.Builder()
        .setModifiers(
            ModifiersBuilders.Modifiers.Builder()
                .setClickable(
                    ModifiersBuilders.Clickable.Builder()
                        .setId(title)
                        .setOnClick(clickable)
                        .build()
                )
                .setPadding(
                    ModifiersBuilders.Padding.Builder()
                        .setAll(DimensionBuilders.dp(14f))
                        .build()
                )
                .build()
        )
        .addContent(text(title, 14f, false))

    main.forEach { column.addContent(it) }
    if (bottom.isNotEmpty()) {
        val row = LayoutElementBuilders.Row.Builder()
        bottom.forEach { row.addContent(it) }
        column.addContent(row.build())
    }

    return LayoutElementBuilders.Box.Builder()
        .setModifiers(
            ModifiersBuilders.Modifiers.Builder()
                .setBackground(
                    ModifiersBuilders.Background.Builder()
                        .setColor(surface)
                        .setCorner(ModifiersBuilders.Corner.Builder().setRadius(DimensionBuilders.dp(20f)).build())
                        .build()
                )
                .build()
        )
        .addContent(column.build())
        .build()
}

fun root(
    deviceParameters: DeviceParametersBuilders.DeviceParameters,
    content: LayoutElementBuilders.LayoutElement
): LayoutElementBuilders.LayoutElement {
    return LayoutElementBuilders.Box.Builder()
        .setWidth(DimensionBuilders.expand())
        .setHeight(DimensionBuilders.expand())
        .addContent(content)
        .build()
}

fun launchAction(screen: String): ActionBuilders.Action {
    return ActionBuilders.LaunchAction.Builder()
        .setAndroidActivity(
            ActionBuilders.AndroidActivity.Builder()
                .setPackageName("com.pathofnur.watch")
                .setClassName("com.pathofnur.watch.MainActivity")
                .setKey(screen)
                .setUrl("pathofnurwatch://open/$screen")
                .build()
        )
        .build()
}

fun broadcastAction(action: String): ActionBuilders.Action {
    val route = when (action) {
        TileRoutes.ACTION_DHIKR_INCREMENT -> "pathofnurwatch://open/${TileRoutes.SCREEN_DHIKR}?tileAction=increment"
        TileRoutes.ACTION_DHIKR_RESET -> "pathofnurwatch://open/${TileRoutes.SCREEN_DHIKR}?tileAction=reset"
        else -> "pathofnurwatch://open/${TileRoutes.SCREEN_DHIKR}"
    }
    return ActionBuilders.LaunchAction.Builder()
        .setAndroidActivity(
            ActionBuilders.AndroidActivity.Builder()
                .setPackageName("com.pathofnur.watch")
                .setClassName("com.pathofnur.watch.MainActivity")
                .setKey(action)
                .setUrl(route)
                .build()
        )
        .build()
}
